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
  type        = string
  description = "The Google Cloud project ID"
}

variable "bastion_region" {
  type        = string
  description = "The region of the GCP subnetwork for bastion services"
}

variable "bastion_subnet" {
  type        = string
  description = "The name of the GCP subnetwork for bastion services"
}

variable "network_project_id" {
  type        = string
  description = "The project id of the GCP subnetwork for bastion services"
}

variable "vpc_name" {
  type        = string
  description = "The name of the bastion VPC"
}

variable "bastion_name" {
  type        = string
  description = "The name of the bastion server"
}

variable "bastion_zone" {
  type        = string
  description = "The zone for the bastion VM"
}

variable "bastion_service_account_name" {
  type        = string
  description = "The service account to be created for the bastion."
}

variable "bastion_members" {
  type        = list(string)
  description = "The emails of the members with access to the bastion server"
}

variable "repo_project_id" {
  type        = string
  description = "The project where app repos exist"
}
