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
  description = "The environment to prepare (ex. development)."
}

variable "env_short" {
  type        = string
  description = "The environment to prepare (ex. dev)."
}

variable "environment_code" {
  type        = string
  description = "A short form of the folder level resources (environment) within the Google Cloud organization (ex. d)."
}

variable "business_unit" {
  type        = string
  description = "A short form of the business unit level projects within the Google Cloud organization (ex. bu1)."
  default     = "bu1"
}

variable "parent_folder" {
  type        = string
  description = "The parent folder or org for environments."
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
  description = "The primary region for deployment, if not set default locations for each resource are taken from variables file"
  default     = "us-east1"
}

variable "location_secondary" {
  type        = string
  description = "The secondary region for deployment, if not set default locations for each resource are taken from variables file"
  default     = "us-west1"
}

variable "log_storage_bucket_location" {
  type        = string
  description = "The region the storage bucket for logs is located."
  default     = "US-WEST1"
}

variable "log_storage_bucket_project" {
  type        = string
  description = "The project that will contain the storage bucket for logs, if not set, OPS project is taken by default"
  default     = ""
}

variable "kms_location_1" {
  type        = string
  description = "The location of the first set of GKE, SQL - KMS keyring and keys. Only if Primary region value, is not given"
  default     = "us-east1"
}

variable "kms_location_2" {
  type        = string
  description = "The location of the second set of GKE, SQL - KMS keyring and keys. Only if Secondary region value, is not given"
  default     = "us-west1"
}

variable "gcp_shared_vpc_project_id" {
  type        = string
  description = "The host project id of the shared VPC."
}

variable "bastion_zone" {
  type        = string
  description = "The zone for the bastion VM in primary region"
  default     = "us-west1-b"
}

variable "bastion_subnet_name" {
  type        = string
  description = "The name of the subnet for the shared VPC."
  default     = "bastion-host-subnet"
}

variable "bastion_subnet_region" {
  type        = string
  description = "The region the shared VPC will be located in. Only if Primary region value, is not given"
  default     = "us-east1"
}

variable "bastion_members" {
  type        = list(string)
  description = "The names of the members of the bastion server."
  default     = []
}

variable "gke_cluster_1_location" {
  type        = string
  description = "The location of the first GKE cluster.  Only if Primary region value, is not given"
  default     = "us-east1"
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

variable "gke_cluster_1_machine_type" {
  type        = string
  description = "The type of VM that will be used for the first GKE cluster (ex. e2-micro)."
  default     = "e2-standard-4"
}

variable "gke_cluster_2_location" {
  type        = string
  description = "The location of the second GKE cluster.  Only if Secondary region value, is not given"
  default     = "us-west1"
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

variable "gke_cluster_2_machine_type" {
  type        = string
  description = "The type of VM that will be used for the second GKE cluster (ex. e2-micro)."
  default     = "e2-standard-4"
}

variable "gke_mci_cluster_location" {
  type        = string
  description = "The location for multi-cluster ingress (MCI). Only if primary region value, is not given"
  default     = "us-east1"
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

variable "gke_mci_cluster_machine_type" {
  type        = string
  description = "The type of VM that will be used for multi-cluster ingress (MCI)."
  default     = "e2-standard-2"
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

variable "sql_1_admin_user" {
  #sensitive  = true
  type        = string
  description = "The SQL admin's username."
  default     = "testuser"
}

variable "sql_1_admin_password" {
  #sensitive  = true
  type        = string
  description = "The SQL admin's password."
  default     = "foobar"
}

variable "sql_1_database_region" {
  type        = string
  description = "The location of the SQL database. Only if primary region value, is not given"
  default     = "us-east1"
}

variable "sql_1_database_users" {
  type = list(object({
    name     = string
    password = string
    host     = string
  }))
  description = "Allowed list of members (users and/or service accounts) that need access to the SQL database."
  default     = []
}

variable "sql_1_database_zone" {
  type        = string
  description = "The database zone in primary region"
  default     = "us-east1-c"
}

variable "sql_1_replica_zones" {
  type = object({
    zone1 = string
    zone2 = string
    zone3 = string
  })
  description = "The database zones in primary region for read replicas"
  default = {
    zone1 = "us-central1-a",
    zone2 = "us-central1-c",
    zone3 = "us-central1-f"
  }
}

variable "sql_2_admin_user" {
  #sensitive  = true
  type        = string
  description = "The SQL admin's username."
  default     = "testuser"
}

variable "sql_2_admin_password" {
  #sensitive  = true
  type        = string
  description = "The SQL admin's password."
  default     = "foobar"
}

variable "sql_2_database_region" {
  type        = string
  description = "The location of the 2nd SQL database. Only if Secondary region value, is not given"
  default     = "us-west1"
}

variable "sql_2_database_users" {
  type = list(object({
    name     = string
    password = string
    host     = string
  }))
  description = "Allowed list of members (users and/or service accounts) that need access to the SQL database."
  default = [
    {
      name     = "tftest2"
      password = "abcdefg"
      host     = "localhost"
    },
    {
      name     = "tftest3"
      password = "abcdefg"
      host     = "localhost"
    },
  ]
}

variable "sql_2_database_zone" {
  type        = string
  description = "The database zone for the 2nd SLQ Instance in secondary region"
  default     = "us-west1-a"
}

variable "sql_2_replica_zones" {
  type = object({
    zone1 = string
    zone2 = string
    zone3 = string
  })
  description = "The database zone for read replicas in secondary region"
  default = {
    zone1 = "us-central1-a",
    zone2 = "us-central1-c",
    zone3 = "us-central1-f"
  }
}
