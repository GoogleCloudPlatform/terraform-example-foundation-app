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

variable "boa_gke_cluster1_master_cidr" {
  description = "Master CIDR for GKE Cluster 1"
  type        = string
}

variable "boa_gke_cluster2_master_cidr" {
  description = "Master CIDR for GKE Cluster 2"
  type        = string
}

variable "boa_gke_mci_master_cidr" {
  description = "Master CIDR for MCI GKE Cluster"
  type        = string
}

variable "fw_project_id" {
  description = "Project ID"
  type        = string
}

variable "firewall_enable_logging" {
  description = "Logging Enable or Disable"
  type        = bool
}

variable "network_link" {
  description = "VPC Network Self Link"
  type        = string
}

variable "environment_code" {
  description = "VPC Network Self Link"
  type        = string
}
