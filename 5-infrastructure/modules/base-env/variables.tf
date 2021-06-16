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

variable "env" {
  type        = string
  description = "The environment to prepare (dev/npd/prd)."
}

variable "terraform_service_account" {
  type        = string
  description = "Service account email of the account to impersonate to run Terraform."
}

variable "project_prefix" {
  type        = string
  description = "Name prefix to use for projects created."
  default     = "prj"
}

variable "folder_prefix" {
  type        = string
  description = "Name prefix to use for folders created."
  default     = "fldr"
}

variable "location_primary" {
  type        = string
  description = "The primary region for deployment, if not set default locations for each resource are taken from variables file."
  default     = "us-east1"
}

variable "location_secondary" {
  type        = string
  description = "The secondary region for deployment, if not set default locations for each resource are taken from variables file."
  default     = "us-west1"
}

variable "gcp_shared_vpc_project_id" {
  type        = string
  description = "The host project id of the shared VPC."
}

variable "shared_vpc_name" {
  type        = string
  description = "The shared VPC network name."
}

variable "bastion_zone" {
  type        = string
  description = "The zone for the bastion VM in primary region."
  default     = "us-west1-b"
}

variable "bastion_subnet_name" {
  type        = string
  description = "The name of the subnet for the shared VPC."
  default     = "bastion-host-subnet"
}

variable "bastion_members" {
  type        = list(string)
  description = "The emails of the members with access to the bastion server."
  default     = []
}

variable "gke_cluster_1_cidr_block" {
  type        = string
  description = "The primary IPv4 cidr block for the first GKE cluster."
}

variable "gke_cluster_1_subnet_name" {
  type        = string
  description = "The name of the subnet for the first GKE cluster."
  default     = "gke-cluster1-subnet"
}

variable "gke_cluster_1_range_name_pods" {
  type        = string
  description = "The name of the pods IP range for the first GKE cluster."
  default     = "pod-ip-range"
}

variable "gke_cluster_1_range_name_services" {
  type        = string
  description = "The name of the services IP range for the first GKE cluster."
  default     = "services-ip-range"
}

variable "gke_cluster_2_cidr_block" {
  type        = string
  description = "The primary IPv4 cidr block for the second GKE cluster."
}

variable "gke_cluster_2_subnet_name" {
  type        = string
  description = "The name of the subnet for the second GKE cluster."
  default     = "gke-cluster2-subnet"
}

variable "gke_cluster_2_range_name_pods" {
  type        = string
  description = "The name of the pods IP range for the second GKE cluster."
  default     = "pod-ip-range"
}

variable "gke_cluster_2_range_name_services" {
  type        = string
  description = "The name of the services IP range for the second GKE cluster."
  default     = "services-ip-range"
}

variable "gke_mci_cluster_cidr_block" {
  type        = string
  description = "The primary IPv4 cidr block for multi-cluster ingress (MCI)."
}

variable "gke_mci_cluster_subnet_name" {
  type        = string
  description = "The name of the subnet for multi-cluster ingress (MCI)."
  default     = "mci-config-subnet"
}

variable "gke_mci_cluster_range_name_pods" {
  type        = string
  description = "The name of the pods IP range for multi-cluster ingress (MCI)."
  default     = "pod-ip-range"
}

variable "gke_mci_cluster_range_name_services" {
  type        = string
  description = "The name of the services IP range for multi-cluster ingress (MCI)."
  default     = "services-ip-range"
}

variable "max_pods_per_node" {
  type        = number
  description = "The maximum number of pods to schedule per node"
  default     = 64
}

variable "boa_gke_project_id" {
  type        = string
  description = "Project ID for GKE."
}

variable "boa_ops_project_id" {
  type        = string
  description = "Project ID for ops."
}

variable "boa_sec_project_id" {
  type        = string
  description = "Project ID for secrets."
}

variable "boa_sql_project_id" {
  type        = string
  description = "Project ID for SQL."
}

variable "sql_database_replication_region" {
  type        = string
  description = "SQL Instance Replica Region."
  default     = "us-central1"
}

variable "sql_admin_username" {
  type        = string
  description = "Admin Username for SQL Instances."
  default     = "admin"
}

variable "sql_admin_password" {
  type        = string
  description = "Admin Password for SQL Instances."
  default     = "admin"
}

variable "enforce_bin_auth_policy" {
  type        = bool
  description = "Enable or Disable creation of binary authorization policy."
  default     = false
}

variable "bin_auth_attestor_names" {
  type        = list(string)
  description = "Binary Authorization Attestor Names set up in shared app_cicd project."
  default     = []
}

variable "bin_auth_attestor_project_id" {
  type        = string
  description = "Project Id where binary attestors are created."
}
