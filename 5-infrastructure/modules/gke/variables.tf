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

variable cluster_name {
  type        = string
  description = "The name of the GKE cluster"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The IPv4 cidr block for the masters"
}

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string,
    display_name = string
  }))
}

variable "network_name" {
  type        = string
  description = "The name of the VPC network"
}

variable node_pools {
  type        = list(map(string))
  description = "List of Node Pool objects"
}

variable project_id {
  type        = string
  description = "The Google Cloud project ID"
}

variable "range_name_pods" {
  type        = string
  description = "The name of the subnet secondary range for pods"
}

variable "range_name_services" {
  type        = string
  description = "The name of the subnet secondary range for services"
}

variable "region" {
  type        = string
  description = "The Google Cloud region, e.g. us-central1"
}

variable "subnetwork_name" {
  type        = string
  description = "The name of the VPC subnetwork"
}

variable "network_project_id" {
  type        = string
  description = "The project id of the VPC subnetwork"
}
