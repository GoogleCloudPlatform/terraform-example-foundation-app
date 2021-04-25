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
    sql1 = {
      database_zone = "${var.location_primary}-c",
      database_name = "ledger-db",
      replica_zones = {
        zone1 = "${var.sql_database_replication_region}-a",
        zone2 = "${var.sql_database_replication_region}-c"
      }
      sql_instance_prefix = "boa-sql-1-${local.envs[var.env].short}-${var.location_primary}",
      database_region     = var.location_primary
    },
    sql2 = {
      database_zone = "${var.location_secondary}-a",
      database_name = "accounts-db",
      replica_zones = {
        zone1 = "${var.sql_database_replication_region}-a",
        zone2 = "${var.sql_database_replication_region}-c"
      }
      sql_instance_prefix = "boa-sql-2-${local.envs[var.env].short}-${var.location_secondary}",
      database_region     = var.location_secondary
    }
  }
}

module "sink_sql" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 6.0"
  destination_uri        = module.log_destination.destination_uri
  filter                 = "resource.type:(cloudsql_database OR service_account OR global OR audited_resource OR project)"
  log_sink_name          = "sink-boa-${local.envs[var.env].short}-sql-to-ops"
  parent_resource_id     = var.boa_sql_project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

data "google_compute_network" "vpc" {
  project = var.gcp_shared_vpc_project_id
  name    = var.shared_vpc_name
}

data "google_compute_subnetwork" "subnet" {
  for_each  = toset(data.google_compute_network.vpc.subnetworks_self_links)
  self_link = each.value
}

module "sql" {
  source   = "../cloud-sql"
  for_each = local.sql_settings

  database_name       = each.value.database_name
  database_zone       = each.value.database_zone
  replica_zones       = each.value.replica_zones
  sql_instance_prefix = each.value.sql_instance_prefix
  database_region     = each.value.database_region

  admin_user     = var.sql_admin_username
  admin_password = var.sql_admin_password
  project_id     = var.boa_sql_project_id
  vpc_self_link  = data.google_compute_network.vpc.self_link

  # Secondary IP ranges from all GKE subnets in Shared VPC
  authorized_networks = [for range in flatten([for subnet in data.google_compute_subnetwork.subnet : subnet.secondary_ip_range if length(subnet.secondary_ip_range) > 0]) : zipmap(["value", "name"], values(range))]
}
