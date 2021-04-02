/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
locals {
  sql_settings = {
    sql_1 = {
      database_zone        = "${var.location_primary}-a",
      database_name        = "ledger-db",
      database_users       = [],
      additional_databases = [],
      replica_zones = {
        zone1 = "${var.sql_database_replication_region}-a",
        zone2 = "${var.sql_database_replication_region}-c",
        zone3 = "${var.sql_database_replication_region}-f"
      }
      encrypt_keyring_name = module.kms_keyrings_keys["kms_sql_1"].keyring_name,
      sql_instance_prefix  = "sql-boa-${var.location_primary}-01",
      database_region      = var.location_primary
    },
    sql_2 = {
      database_zone        = "${var.location_secondary}-a",
      database_name        = "accounts-db",
      database_users       = [],
      additional_databases = [],
      replica_zones = {
        zone1 = "${var.sql_database_replication_region}-a",
        zone2 = "${var.sql_database_replication_region}-c",
        zone3 = "${var.sql_database_replication_region}-f"
      }
      encrypt_keyring_name = module.kms_keyrings_keys["kms_sql_2"].keyring_name,
      sql_instance_prefix  = "sql-boa-${var.location_secondary}-01",
      database_region      = var.location_secondary
    }
  }
}

module "sink_sql" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 5.2"
  destination_uri        = module.log_destination.destination_uri
  filter                 = "resource.type:(cloudsql_database OR service_account OR global OR audited_resource OR project)"
  log_sink_name          = "sink-boa-sql-${local.envs[var.env].short}-01"
  parent_resource_id     = var.boa_sql_project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

data "google_compute_network" "vpc" {
  project = var.gcp_shared_vpc_project_id
  name    = "vpc-${var.env}-shared-base"
}

data "google_compute_subnetwork" "subnet" {
  for_each  = toset(data.google_compute_network.vpc.subnetworks_self_links)
  self_link = each.value
}

module "private_access" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version     = "~> 5.0"
  project_id  = var.gcp_shared_vpc_project_id
  vpc_network = "vpc-${var.env}-shared-base"
}

module "sql" {
  depends_on = [module.private_access]
  source     = "../cloud-sql"
  for_each   = local.sql_settings

  database_name        = each.value.database_name
  database_users       = each.value.database_users
  database_zone        = each.value.database_zone
  replica_zones        = each.value.replica_zones
  encrypt_keyring_name = each.value.encrypt_keyring_name
  sql_instance_prefix  = each.value.sql_instance_prefix
  database_region      = each.value.database_region

  admin_user         = var.sql_admin_username
  admin_password     = var.sql_admin_password
  project_id         = var.boa_sql_project_id
  vpc_self_link      = data.google_compute_network.vpc.self_link
  network_project_id = var.gcp_shared_vpc_project_id

  # Secondary IP ranges from all GKE subnets in Shared VPC
  authorized_networks = [for range in flatten([for subnet in data.google_compute_subnetwork.subnet : subnet.secondary_ip_range if length(subnet.secondary_ip_range) > 0]) : zipmap(["value", "name"], values(range))]
}
