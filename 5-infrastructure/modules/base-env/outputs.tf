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

output "sql_instance_1_name" {
  description = "The name for Cloud SQL instance"
  value       = module.sql_1.sql_instance_name
}

output "sql_instance_1_private_ip_address" {
  value = module.sql_1.private_ip_address
}

output "sql_instance_2_name" {
  description = "The name for Cloud SQL instance"
  value       = module.sql_2.sql_instance_name
}

output "sql_instance_2_private_ip_address" {
  value = module.sql_2.private_ip_address
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

output "kms_gke_1_keyring" {
  description = "Self link of the keyring."
  value       = module.kms_gke_1.keyring
}

output "kms_gke_1_keyring_resource" {
  description = "Keyring resource."
  value       = module.kms_gke_1.keyring_resource
}

output "kms_gke_1_keys" {
  description = "Map of key name => key self link."
  value       = module.kms_gke_1.keys
}

output "kms_gke_1_keyring_name" {
  description = "Name of the keyring."
  value       = module.kms_gke_1.keyring_name
}

output "kms_gke_2_keyring" {
  description = "Self link of the keyring."
  value       = module.kms_gke_2.keyring
}

output "kms_gke_2_keyring_resource" {
  description = "Keyring resource."
  value       = module.kms_gke_2.keyring_resource
}

output "kms_gke_2_keys" {
  description = "Map of key name => key self link."
  value       = module.kms_gke_2.keys
}

output "kms_gke_2_keyring_name" {
  description = "Name of the keyring."
  value       = module.kms_gke_2.keyring_name
}

output "kms_sql_1_keyring" {
  description = "Self link of the keyring."
  value       = module.kms_sql_1.keyring
}

output "kms_sql_1_keyring_resource" {
  description = "Keyring resource."
  value       = module.kms_sql_1.keyring_resource
}

output "kms_sql_1_keys" {
  description = "Map of key name => key self link."
  value       = module.kms_sql_1.keys
}

output "kms_sql_1_keyring_name" {
  description = "Name of the keyring."
  value       = module.kms_sql_1.keyring_name
}

output "kms_sql_2_keyring" {
  description = "Self link of the keyring."
  value       = module.kms_sql_2.keyring
}

output "kms_sql_2_keyring_resource" {
  description = "Keyring resource."
  value       = module.kms_sql_2.keyring_resource
}

output "kms_sql_2_keys" {
  description = "Map of key name => key self link."
  value       = module.kms_sql_2.keys
}

output "kms_sql_2_keyring_name" {
  description = "Name of the keyring."
  value       = module.kms_sql_2.keyring_name
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

output "bastion_self_link" {
  description = "Self link of the bastion host"
  value       = module.bastion.self_link
}

output "bastion_service_account_email" {
  description = "Email address of the SA created for the bastion host"
  value       = module.bastion.service_account_email
}

output "bastion_cidr_range" {
  description = "Self link of the bastion host"
  value       = module.bastion.cidr_range
}

output "bastion_subnet_name" {
  description = "Self link of the bastion host"
  value       = module.bastion.subnet_name
}


/******************************************
  GKE Outputs
*****************************************/

output "cluster_1_name" {
  description = "Cluster name"
  value       = module.cluster_1.name
}

output "cluster_1_type" {
  description = "Cluster type (regional / zonal)"
  value       = module.cluster_1.type
}

output "cluster_1_location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.cluster_1.location
}

output "cluster_1_region" {
  description = "Cluster region"
  value       = module.cluster_1.region
}

output "cluster_1_zones" {
  description = "List of zones in which the cluster resides"
  value       = module.cluster_1.zones
}

output "cluster_1_endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.cluster_1.endpoint
}

output "cluster_1_logging_service" {
  description = "Logging service used"
  value       = module.cluster_1.logging_service
}

output "cluster_1_monitoring_service" {
  description = "Monitoring service used"
  value       = module.cluster_1.monitoring_service
}

output "cluster_1_master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = module.cluster_1.master_authorized_networks_config
}

output "cluster_1_ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.cluster_1.ca_certificate
}

output "cluster_1_network_policy_enabled" {
  description = "Whether network policy enabled"
  value       = module.cluster_1.network_policy_enabled
}

output "cluster_1_http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = module.cluster_1.http_load_balancing_enabled
}

output "cluster_1_horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = module.cluster_1.horizontal_pod_autoscaling_enabled
}

output "cluster_1_node_pools_names" {
  description = "List of node pools names"
  value       = module.cluster_1.node_pools_names
}

output "cluster_1_node_pools_versions" {
  description = "List of node pools versions"
  value       = module.cluster_1.node_pools_versions
}

output "cluster_1_service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = module.cluster_1.service_account
}

output "cluster_1_master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation used for the hosted master network"
  value       = module.cluster_1.master_ipv4_cidr_block
}

output "cluster_1_peering_name" {
  description = "The name of the peering between this cluster and the Google owned VPC."
  value       = module.cluster_1.peering_name
}

output "cluster_2_name" {
  description = "Cluster name"
  value       = module.cluster_2.name
}

output "cluster_2_type" {
  description = "Cluster type (regional / zonal)"
  value       = module.cluster_2.type
}

output "cluster_2_location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.cluster_2.location
}

output "cluster_2_region" {
  description = "Cluster region"
  value       = module.cluster_2.region
}

output "cluster_2_zones" {
  description = "List of zones in which the cluster resides"
  value       = module.cluster_2.zones
}

output "cluster_2_endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.cluster_2.endpoint
}

output "cluster_2_logging_service" {
  description = "Logging service used"
  value       = module.cluster_2.logging_service
}

output "cluster_2_monitoring_service" {
  description = "Monitoring service used"
  value       = module.cluster_2.monitoring_service
}

output "cluster_2_master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = module.cluster_2.master_authorized_networks_config
}

output "cluster_2_ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.cluster_2.ca_certificate
}

output "cluster_2_network_policy_enabled" {
  description = "Whether network policy enabled"
  value       = module.cluster_2.network_policy_enabled
}

output "cluster_2_http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = module.cluster_2.http_load_balancing_enabled
}

output "cluster_2_horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = module.cluster_2.horizontal_pod_autoscaling_enabled
}

output "cluster_2_node_pools_names" {
  description = "List of node pools names"
  value       = module.cluster_2.node_pools_names
}

output "cluster_2_node_pools_versions" {
  description = "List of node pools versions"
  value       = module.cluster_2.node_pools_versions
}

output "cluster_2_service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = module.cluster_2.service_account
}

output "cluster_2_master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation used for the hosted master network"
  value       = module.cluster_2.master_ipv4_cidr_block
}

output "cluster_2_peering_name" {
  description = "The name of the peering between this cluster and the Google owned VPC."
  value       = module.cluster_2.peering_name
}

output "mci_cluster_name" {
  description = "Cluster name"
  value       = module.mci_cluster.name
}

output "mci_cluster_type" {
  description = "Cluster type (regional / zonal)"
  value       = module.mci_cluster.type
}

output "mci_cluster_location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.mci_cluster.location
}

output "mci_cluster_region" {
  description = "Cluster region"
  value       = module.mci_cluster.region
}

output "mci_cluster_zones" {
  description = "List of zones in which the cluster resides"
  value       = module.mci_cluster.zones
}

output "mci_cluster_endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.mci_cluster.endpoint
}

output "mci_cluster_logging_service" {
  description = "Logging service used"
  value       = module.mci_cluster.logging_service
}

output "mci_cluster_monitoring_service" {
  description = "Monitoring service used"
  value       = module.mci_cluster.monitoring_service
}

output "mci_cluster_master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = module.mci_cluster.master_authorized_networks_config
}

output "mci_cluster_ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.mci_cluster.ca_certificate
}

output "mci_cluster_network_policy_enabled" {
  description = "Whether network policy enabled"
  value       = module.mci_cluster.network_policy_enabled
}

output "mci_cluster_http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = module.mci_cluster.http_load_balancing_enabled
}

output "mci_cluster_horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = module.mci_cluster.horizontal_pod_autoscaling_enabled
}

output "mci_cluster_node_pools_names" {
  description = "List of node pools names"
  value       = module.mci_cluster.node_pools_names
}

output "mci_cluster_node_pools_versions" {
  description = "List of node pools versions"
  value       = module.mci_cluster.node_pools_versions
}

output "mci_cluster_service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = module.mci_cluster.service_account
}

output "mci_cluster_master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation used for the hosted master network"
  value       = module.mci_cluster.master_ipv4_cidr_block
}

output "mci_cluster_peering_name" {
  description = "The name of the peering between this cluster and the Google owned VPC."
  value       = module.mci_cluster.peering_name
}
