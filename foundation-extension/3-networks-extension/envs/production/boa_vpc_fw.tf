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
 Base shared VPC
*****************************************/

module "base_shared_vpc" {
  source                        = "../../modules/base_shared_vpc"
  project_id                    = local.base_project_id
  environment_code              = local.environment_code
  private_service_cidr          = local.base_private_service_cidr
  org_id                        = var.org_id
  parent_folder                 = var.parent_folder
  default_region1               = var.default_region1
  default_region2               = var.default_region2
  domain                        = var.domain
  bgp_asn_subnet                = local.bgp_asn_number
  windows_activation_enabled    = var.windows_activation_enabled
  dns_enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  dns_enable_logging            = var.dns_enable_logging
  firewall_enable_logging       = var.firewall_enable_logging
  optional_fw_rules_enabled     = var.optional_fw_rules_enabled
  nat_enabled                   = var.nat_enabled
  nat_bgp_asn                   = var.nat_bgp_asn
  nat_num_addresses_region1     = var.nat_num_addresses_region1
  nat_num_addresses_region2     = var.nat_num_addresses_region2
  nat_num_addresses             = var.nat_num_addresses
  folder_prefix                 = var.folder_prefix
  mode                          = local.mode

  subnets = [
    {
      subnet_name           = "mci-config-subnet"
      subnet_ip             = "10.0.192.0/29"
      subnet_region         = var.default_region1
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "The mci config example subnet."
    },
    {
      subnet_name           = "gke-cluster1-subnet"
      subnet_ip             = "10.0.193.0/29"
      subnet_region         = var.default_region1
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "The mci config example subnet."
    },
    {
      subnet_name           = "bastion-host-subnet"
      subnet_ip             = "10.0.194.0/29"
      subnet_region         = var.default_region2
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "The bastion host example subnet."
    },
    {
      subnet_name           = "gke-cluster2-subnet"
      subnet_ip             = "10.1.192.0/29"
      subnet_region         = var.default_region2
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "The bastion host example subnet."
    },
  ]

  secondary_ranges = {
    mci-config-subnet = [
      {
        range_name    = "pod-ip-range"
        ip_cidr_range = "100.64.192.0/22"
      },
      {
        range_name    = "services-ip-range"
        ip_cidr_range = "100.64.196.0/26"
      }
    ]

    gke-cluster1-subnet = [
      {
        range_name    = "pod-ip-range"
        ip_cidr_range = "100.64.200.0/22"
      },
      {
        range_name    = "services-ip-range"
        ip_cidr_range = "100.64.204.0/26"
      }
    ]

    bastion-host-subnet = []

    gke-cluster2-subnet = [
      {
        range_name    = "pod-ip-range"
        ip_cidr_range = "100.65.192.0/22"
      },
      {
        range_name    = "services-ip-range"
        ip_cidr_range = "100.65.196.0/26"
      }
    ]
  }
  allow_all_ingress_ranges = local.enable_transitivity ? local.base_hub_subnet_ranges : null
  allow_all_egress_ranges  = local.enable_transitivity ? local.base_subnet_aggregates : null
}

/******************************************
 Firewall Rules
*****************************************/

module "boa_firewall_rules" {
  source = "../../modules/fw-rules"

  environment_code             = local.environment_code
  network_link                 = module.base_shared_vpc.network_self_link
  fw_project_id                = local.base_project_id
  firewall_enable_logging      = var.firewall_enable_logging
  boa_gke_cluster1_master_cidr = "100.64.206.0/28"
  boa_gke_cluster2_master_cidr = "100.65.198.0/28"
  boa_gke_mci_master_cidr      = "100.64.198.0/28"
}
