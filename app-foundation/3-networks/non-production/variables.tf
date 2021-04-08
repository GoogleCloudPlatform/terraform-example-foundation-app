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

variable "org_id" {
  type        = string
  description = "Organization ID"
}

variable "access_context_manager_policy_id" {
  type        = number
  description = "The id of the default Access Context Manager policy created in step `1-org`. Can be obtained by running `gcloud access-context-manager policies list --organization YOUR-ORGANIZATION_ID --format=\"value(name)\"`."
}

variable "terraform_service_account" {
  type        = string
  description = "Service account email of the account to impersonate to run Terraform."
}

variable "default_region1" {
  type        = string
  description = "First subnet region. The shared vpc modules only configures two regions."
}

variable "default_region2" {
  type        = string
  description = "Second subnet region. The shared vpc modules only configures two regions."
}

variable "domain" {
  type        = string
  description = "The DNS name of peering managed zone, for instance 'example.com.'"
}

variable "dns_enable_logging" {
  type        = bool
  description = "Toggle DNS logging for VPC DNS."
  default     = true
}

variable "subnetworks_enable_logging" {
  type        = bool
  description = "Toggle subnetworks flow logging for VPC Subnetworks."
  default     = true
}

variable "firewall_enable_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls."
  default     = true
}

variable "dns_enable_inbound_forwarding" {
  type        = bool
  description = "Toggle inbound query forwarding for VPC DNS."
  default     = true
}

variable "windows_activation_enabled" {
  type        = bool
  description = "Enable Windows license activation for Windows workloads."
  default     = false
}

variable "nat_enabled" {
  type        = bool
  description = "Toggle creation of NAT cloud router."
  default     = false
}

variable "nat_bgp_asn" {
  type        = number
  description = "BGP ASN for first NAT cloud routes."
  default     = 64514
}

variable "nat_num_addresses_region1" {
  type        = number
  description = "Number of external IPs to reserve for first Cloud NAT."
  default     = 2
}

variable "nat_num_addresses_region2" {
  type        = number
  description = "Number of external IPs to reserve for second Cloud NAT."
  default     = 2
}

variable "nat_num_addresses" {
  type        = number
  description = "Number of external IPs to reserve for Cloud NAT."
  default     = 2
}

variable "optional_fw_rules_enabled" {
  type        = bool
  description = "Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges."
  default     = false
}

variable "parent_folder" {
  description = "Optional - if using a folder for testing."
  type        = string
  default     = ""
}

variable "folder_prefix" {
  description = "Name prefix to use for folders created."
  type        = string
  default     = "fldr"
}

variable "enable_hub_and_spoke" {
  description = "Enable Hub-and-Spoke architecture."
  type        = bool
  default     = false
}

variable "enable_partner_interconnect" {
  description = "Enable Partner Interconnect in the environment."
  type        = bool
  default     = false
}

variable "preactivate_partner_interconnect" {
  description = "Preactivate Partner Interconnect VLAN attachment in the environment."
  type        = bool
  default     = false

}
variable "enable_hub_and_spoke_transitivity" {
  description = "Enable transitivity via gateway VMs on Hub-and-Spoke architecture."
  type        = bool
  default     = false
}

/******************************************
 Variables for secure application subnets
*****************************************/

variable "environment_code" {
  description = "Short form for the environment to deploy into."
  type        = string

}

variable "env" {
  description = "The environment to deploy into."
  type        = string
}

variable "subnets" {
  description = "The list of subnets being created for the application."
  type        = list(map(string))
}

variable "secondary_ranges" {
  description = "Secondary ranges that will be used in some of the application's subnets."
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  default     = {}
}

variable "private_service_address_name" {
  description = "The name of the private service access address."
  type        = string
  default     = null
}

/******************************************
 Variables for VPC firewall rules
*****************************************/

variable "boa_gke1_cluster_cidr" {
  description = "The master CIDR of the first GKE cluster."
  type        = string
}

variable "boa_gke2_cluster_cidr" {
  description = "The master CIDR of the second GKE cluster."
  type        = string
}

variable "boa_mci_cluster_cidr" {
  description = "The master CIDR of the MCI cluster."
  type        = string
}

/******************************************
 Variables for external IP
*****************************************/

variable "address_name" {
  description = "What the external IP address will be used for."
  type        = string
}

variable "address_type" {
  description = "Determines if the IP address will be internal or external."
  type        = string
}

variable "description" {
  description = "What the external IP address will be used for."
  type        = string
}

variable "region" {
  description = "The region that the external IP will be created in."
  type        = string
}

/******************************************
 Variables for Cloud Armor
*****************************************/

variable "policy_name" {
  description = "Name of the Cloud Armor security policy."
  type        = string
}

variable "policy_action" {
  description = "Specify if you want to allow or deny traffic."
  type        = string
}

variable "policy_priority" {
  description = "Priority level for policy - lower numbers have higher priority."
  type        = string
}

variable "policy_expression" {
  description = "Expression used to configure what is intended to match the policy."
  type        = string
}

variable "policy_description" {
  description = "Description of the security policy."
  type        = string
}
