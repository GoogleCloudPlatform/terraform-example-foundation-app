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

output "sql_1_instance_name" {
  description = "PostgreSQL Instance 1 Name"
  value       = module.env.sql_outputs.sql1["Instance Name"]
}

output "sql_1_ip_address" {
  description = "PostgreSQL Instance 1 Private Ip"
  value       = module.env.sql_outputs.sql1["Private IP Address"]
}

output "sql_2_instance_name" {
  description = "PostgreSQL Instance 2 Name"
  value       = module.env.sql_outputs.sql2["Instance Name"]
}

output "sql_2_ip_address" {
  description = "PostgreSQL Instance 2 Private Ip"
  value       = module.env.sql_outputs.sql2["Private IP Address"]
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

/******************************************
  GKE Outputs
*****************************************/

output "gke_1_cluster_name" {
  description = "Cluster 1 Name"
  value       = module.env.gke_outputs.gke1["Cluster Name"]
}

output "gke_1_master_ipv4" {
  description = "Cluster 1 Master IPV4 Address CIDR"
  value       = module.env.gke_outputs.gke1["Master IPV4 Address CIDR"]
}

output "gke_1_region" {
  description = "Cluster 1 Region"
  value       = module.env.gke_outputs.gke1["Region"]
}

output "gke_2_cluster_name" {
  description = "Cluster 2 Name"
  value       = module.env.gke_outputs.gke2["Cluster Name"]
}

output "gke_2_master_ipv4" {
  description = "Cluster 2 Master IPV4 Address CIDR"
  value       = module.env.gke_outputs.gke2["Master IPV4 Address CIDR"]
}

output "gke_2_region" {
  description = "Cluster 2 Region"
  value       = module.env.gke_outputs.gke2["Region"]
}

output "mci_cluster_name" {
  description = "MCI Cluster Name"
  value       = module.env.gke_outputs.mci["Cluster Name"]
}

output "mci_master_ipv4" {
  description = "MCI Cluster Master IPV4 Address CIDR"
  value       = module.env.gke_outputs.mci["Master IPV4 Address CIDR"]
}

output "mci_region" {
  description = "MCI Cluster Region"
  value       = module.env.gke_outputs.mci["Region"]
}

/******************************************
  External IP Outputs
*****************************************/

output "external_ip_address" {
  description = "The external IP for HTTP load balancing."
  value       = module.env.external_ip_address
}
