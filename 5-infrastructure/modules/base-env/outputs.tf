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
  description = "Outputs for Cloud SQL instances."
  value       = tomap({ for key, instance in module.sql : key => { "Instance Name" = instance.sql_instance_name, "Private IP Address" = instance.private_ip_address } })
}

/******************************************
  KMS Outputs
*****************************************/

output "kms_outputs" {
  description = "Outputs for KMS Keyrings and Keys."
  value       = tomap({ for key, ring in module.kms_keyrings_keys : key => { "Keyring" = ring.keyring_name, "Keys" = ring.keys } })
}

/******************************************
  Bastion Host Outputs
*****************************************/

output "bastion_hostname" {
  description = "Host name of the bastion."
  value       = module.bastion.hostname
}

output "bastion_ip_address" {
  description = "Internal IP address of the bastion host."
  value       = module.bastion.ip_address
}

output "bastion_service_account_email" {
  description = "Email address of the SA created for the bastion host."
  value       = module.bastion.service_account_email
}

/******************************************
  GKE Outputs
*****************************************/
output "gke_outputs" {
  description = "Outputs for Cloud SQL instances."
  value       = tomap({ for key, cluster in module.clusters : key => { "Cluster Name" = cluster.name, "Region" = cluster.region, "Master IPV4 Address CIDR" = cluster.master_ipv4_cidr_block } })
}

/******************************************
  External IP Outputs
*****************************************/

output "external_ip_address" {
  description = "The external IP for HTTP load balancing."
  value       = google_compute_global_address.external_ip_for_http_load_balancing.address
}
