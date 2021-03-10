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

variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "network_project_id" {
  description = "The project ID to host the cluster in"
}

variable "network" {
  description = "The VPC network to host the cluster in"
  default     = "vpc-d-shared-private"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  default     = "sb-d-shared-private-us-central1"
}

variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
  default     = "rn-d-shared-private-us-central1-gke-pod"
}

variable "ip_range_services" {
  description = "The secondary ip range to use for services"
  default     = "rn-d-shared-private-us-central1-gke-svc"
}

variable "master_ipv4_cidr_block" {
  description = "IP range to use for GKE masters."
  type        = string
  default     = "172.16.0.0/28"
}

variable "bastion_member" {
  type        = string
  description = "User, group, SA who need access to the bastion host"
}

variable "terraform_service_account" {
  description = "Service account email of the account to impersonate to run Terraform"
  type        = string
}
