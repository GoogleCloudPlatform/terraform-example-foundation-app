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
  read_replica_ip_configuration = {
    ipv4_enabled        = false
    require_ssl         = false
    private_network     = data.google_compute_network.vpc.self_link
    authorized_networks = [for range in flatten([for subnet in data.google_compute_subnetwork.subnet : subnet.secondary_ip_range if length(subnet.secondary_ip_range) > 0]) : zipmap(["value", "name"], values(range))]
  }
}

module "boa_postgress_ha" {
  depends_on = [google_service_networking_connection.private_vpc_connection]

  source               = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version              = "~> 5.0"
  name                 = var.database_name
  random_instance_name = true
  project_id           = var.project_id
  database_version     = "POSTGRES_13"
  region               = var.database_region

  // Master configurations
  tier                            = "db-custom-2-13312"
  zone                            = var.sql_instance_prefix
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  deletion_protection = false

  database_flags = [{ name = "autovacuum", value = "off" }]

  user_labels = {
    foo = "bar"
  }

  ip_configuration = {
    ipv4_enabled        = false
    require_ssl         = true
    private_network     = data.google_compute_network.vpc.self_link
    authorized_networks = [for range in flatten([for subnet in data.google_compute_subnetwork.subnet : subnet.secondary_ip_range if length(subnet.secondary_ip_range) > 0]) : zipmap(["value", "name"], values(range))]
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "20:55"
    location                       = null
    point_in_time_recovery_enabled = false
  }

  // Read replica configurations
  read_replica_name_suffix = "-test"
  read_replicas = [
    {
      name             = "0"
      zone             = var.replica_zones.zone1
      tier             = "db-custom-2-13312"
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = [{ name = "autovacuum", value = "off" }]
      disk_autoresize  = null
      disk_size        = null
      disk_type        = "PD_HDD"
      user_labels      = { bar = "baz" }
    },
    {
      name             = "1"
      zone             = var.replica_zones.zone2
      tier             = "db-custom-2-13312"
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = [{ name = "autovacuum", value = "off" }]
      disk_autoresize  = null
      disk_size        = null
      disk_type        = "PD_HDD"
      user_labels      = { bar = "baz" }
    },
    {
      name             = "2"
      zone             = var.replica_zones.zone3
      tier             = "db-custom-2-13312"
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = [{ name = "autovacuum", value = "off" }]
      disk_autoresize  = null
      disk_size        = null
      disk_type        = "PD_HDD"
      user_labels      = { bar = "baz" }
    },
  ]

  db_name      = var.database_name
  db_charset   = "UTF8"
  db_collation = "en_US.UTF8"

  user_name     = var.admin_user
  user_password = var.admin_password

  #Optional
  additional_databases = var.additional_databases
  additional_users     = var.database_users
}
