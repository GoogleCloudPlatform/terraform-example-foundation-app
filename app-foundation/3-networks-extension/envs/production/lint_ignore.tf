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

locals {
  environment_code          = "p"
  base_project_id           = ""
  base_private_service_cidr = ""
  bgp_asn_number            = ""
  mode                      = ""
  enable_transitivity       = true
  base_hub_subnet_ranges    = ""
  base_subnet_aggregates    = ""
}

variable "org_id" {
  description = "Fake variable"
}

variable "parent_folder" {
  description = "Fake variable"
}

variable "default_region1" {
  description = "Fake variable"
}

variable "default_region2" {
  description = "Fake variable"
}

variable "domain" {
  description = "Fake variable"
}

variable "windows_activation_enabled" {
  description = "Fake variable"
}

variable "dns_enable_inbound_forwarding" {
  description = "Fake variable"
}

variable "dns_enable_logging" {
  description = "Fake variable"
}

variable "firewall_enable_logging" {
  description = "Fake variable"
}

variable "optional_fw_rules_enabled" {
  description = "Fake variable"
}

variable "nat_enabled" {
  description = "Fake variable"
}

variable "nat_bgp_asn" {
  description = "Fake variable"
}

variable "nat_num_addresses_region1" {
  description = "Fake variable"
}

variable "nat_num_addresses_region2" {
  description = "Fake variable"
}

variable "nat_num_addresses" {
  description = "Fake variable"
}

variable "folder_prefix" {
  description = "Fake variable"
}

variable "subnetworks_enable_logging" {
  description = "Fake variable"
}
