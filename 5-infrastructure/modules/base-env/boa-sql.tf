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

module "sink_sql" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 5.2"
  destination_uri        = module.log_destination.destination_uri
  filter                 = "resource.type:(cloudsql_database OR service_account OR global OR audited_resource OR project)"
  log_sink_name          = "sink-boa-sql-01"
  parent_resource_id     = var.boa_sql_project_id != "" ? var.boa_sql_project_id : local.auto_sql_project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "sql_1" {
  source               = "../cloud-sql"
  admin_user           = var.sql_1_admin_user
  admin_password       = var.sql_1_admin_password
  encrypt_keyring_name = module.kms_sql_1.keyring_name
  sql_instance_prefix  = "sql-boa-${var.location_primary != "" ? var.location_primary : var.sql_1_database_region}-01"
  database_name        = "ledger-db"
  database_region      = var.location_primary != "" ? var.location_primary : var.sql_1_database_region
  database_users       = var.sql_1_database_users
  database_zone        = var.sql_1_database_zone
  project_id           = var.boa_sql_project_id != "" ? var.boa_sql_project_id : local.auto_sql_project_id
  replica_zones        = var.sql_1_replica_zones
  vpc                  = "vpc-${var.env_short}-shared-base"
  network_project_id   = var.gcp_shared_vpc_project_id != "" ? var.gcp_shared_vpc_project_id : local.auto_shared_vpc_project_id
}

module "sql_2" {
  source               = "../cloud-sql"
  admin_user           = var.sql_2_admin_user
  admin_password       = var.sql_2_admin_password
  encrypt_keyring_name = module.kms_sql_2.keyring_name
  sql_instance_prefix  = "sql-boa-${var.location_secondary != "" ? var.location_secondary : var.sql_2_database_region}-01"
  database_name        = "accounts-db"
  database_region      = var.location_secondary != "" ? var.location_secondary : var.sql_2_database_region
  database_users       = var.sql_2_database_users
  database_zone        = var.sql_2_database_zone
  project_id           = var.boa_sql_project_id != "" ? var.boa_sql_project_id : local.auto_sql_project_id
  replica_zones        = var.sql_2_replica_zones
  vpc                  = "vpc-${var.env_short}-shared-base"
  network_project_id   = var.gcp_shared_vpc_project_id != "" ? var.gcp_shared_vpc_project_id : local.auto_shared_vpc_project_id
}
