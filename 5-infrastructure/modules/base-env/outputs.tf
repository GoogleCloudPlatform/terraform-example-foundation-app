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

/******************************************
  SQL Outputs
*****************************************/

output "sql_outputs" {
  description = "Outputs for Cloud SQL instances"
  value       = tomap({ for key, instance in module.sql : key => { "Instance Name" = instance.sql_instance_name, "Private IP Address" = instance.private_ip_address } })
}

/******************************************
  Logging Outputs
*****************************************/

output "ops_log_export_map" {
  description = "Outputs from the log export module"

  value = {
    filter                 = module.sink_ops.filter
    log_sink_resource_id   = module.sink_ops.log_sink_resource_id
    log_sink_resource_name = module.sink_ops.log_sink_resource_name
    parent_resource_id     = module.sink_ops.parent_resource_id
    writer_identity        = module.sink_ops.writer_identity
  }
}

output "sec_log_export_map" {
  description = "Outputs from the log export module"

  value = {
    filter                 = module.sink_sec.filter
    log_sink_resource_id   = module.sink_sec.log_sink_resource_id
    log_sink_resource_name = module.sink_sec.log_sink_resource_name
    parent_resource_id     = module.sink_sec.parent_resource_id
    writer_identity        = module.sink_sec.writer_identity
  }
}

output "gke_log_export_map" {
  description = "Outputs from the log export module"

  value = {
    filter                 = module.sink_gke.filter
    log_sink_resource_id   = module.sink_gke.log_sink_resource_id
    log_sink_resource_name = module.sink_gke.log_sink_resource_name
    parent_resource_id     = module.sink_gke.parent_resource_id
    writer_identity        = module.sink_gke.writer_identity
  }
}

output "sql_log_export_map" {
  description = "Outputs from the log export module"

  value = {
    filter                 = module.sink_sql.filter
    log_sink_resource_id   = module.sink_sql.log_sink_resource_id
    log_sink_resource_name = module.sink_sql.log_sink_resource_name
    parent_resource_id     = module.sink_sql.parent_resource_id
    writer_identity        = module.sink_sql.writer_identity
  }
}

output "logging_destination_map" {
  description = "Outputs from the destination module"

  value = {
    console_link    = module.log_destination.console_link
    project         = module.log_destination.project
    resource_name   = module.log_destination.resource_name
    resource_id     = module.log_destination.resource_id
    self_link       = module.log_destination.self_link
    destination_uri = module.log_destination.destination_uri
  }
}

/******************************************
  KMS Outputs
*****************************************/

output "kms_sa" {
  description = "KMS Service Account"
  value       = google_service_account.kms_service_account.email
}

output "kms_outputs" {
  description = "Outputs for KMS Keyrings and Keys"
  value       = tomap({ for key, ring in module.kms_keyrings_keys : key => { "Keyring" = ring.keyring_name, "Keys" = ring.keys } })
}

/******************************************
  Bastion Host Outputs
*****************************************/

output "bastion_hostname" {
  description = "Host name of the bastion"
  value       = module.bastion.hostname
}

output "bastion_ip_address" {
  description = "Internal IP address of the bastion host"
  value       = module.bastion.ip_address
}

output "bastion_service_account_email" {
  description = "Email address of the SA created for the bastion host"
  value       = module.bastion.service_account_email
}

output "bastion_cidr_range" {
  description = "Self link of the bastion host"
  value       = module.bastion.cidr_range
}

/******************************************
  GKE Outputs
*****************************************/
output "gke_outputs" {
  description = "Outputs for Cloud SQL instances"
  value       = tomap({ for key, cluster in module.clusters : key => { "Cluster Name" = cluster.name, "Region" = cluster.region, "Master IPV4 Address CIDR" = cluster.master_ipv4_cidr_block } })
}
