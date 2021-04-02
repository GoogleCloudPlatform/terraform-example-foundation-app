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
  description = "The name for Cloud SQL instance"
  value       = module.env.sql_outputs
}

/******************************************
  Logging Outputs
*****************************************/

output "ops_log_export_map" {
  description = "Outputs from the log export"
  value       = module.env.ops_log_export_map
}

output "sec_log_export_map" {
  description = "Outputs from the log export"
  value       = module.env.sec_log_export_map
}

output "gke_log_export_map" {
  description = "Outputs from the log export"
  value       = module.env.gke_log_export_map
}

output "sql_log_export_map" {
  description = "Outputs from the log export"
  value       = module.env.sql_log_export_map
}

output "logging_destination_map" {
  description = "Outputs from the destination"
  value       = module.env.logging_destination_map
}

/******************************************
  KMS Outputs
*****************************************/

output "kms_sa" {
  description = "KMS Service Account"
  value       = module.env.kms_sa
}

output "kms_outputs" {
  description = "Outputs for KMS Keyrings and Keys"
  value       = module.env.kms_outputs
}

/******************************************
  Bastion Host Outputs
*****************************************/

output "bastion_hostname" {
  description = "Host name of the bastion"
  value       = module.env.bastion_hostname
}

output "bastion_ip_address" {
  description = "Internal IP address of the bastion host"
  value       = module.env.bastion_ip_address
}

output "bastion_service_account_email" {
  description = "Email address of the SA created for the bastion host"
  value       = module.env.bastion_service_account_email
}

output "bastion_cidr_range" {
  description = "Self link of the bastion host"
  value       = module.env.bastion_cidr_range
}

/******************************************
  GKE Outputs
*****************************************/

output "gke_outputs" {
  description = "Outputs for Cloud SQL instances"
  value       = module.env.gke_outputs
}
