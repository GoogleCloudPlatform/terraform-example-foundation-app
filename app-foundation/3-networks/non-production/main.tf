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
  environment_code    = var.environment_code
  env                 = var.env
  base_project_id     = data.google_projects.base_host_project.projects[0].project_id
  parent_id           = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
  mode                = var.enable_hub_and_spoke ? "spoke" : null
  bgp_asn_number      = var.enable_partner_interconnect ? "16550" : "64514"
  enable_transitivity = var.enable_hub_and_spoke && var.enable_hub_and_spoke_transitivity
  /*
   * Base network ranges
   */
  base_subnet_aggregates    = ["0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0"]
  base_hub_subnet_ranges    = ["0.0.0.0/0", "0.0.0.0/0"]
  base_private_service_cidr = "0.0.0.0/0"
  subnets = {
    for x in var.subnets :
    "${x.subnet_region}/${x.subnet_name}" => x
  }
}

data "google_active_folder" "env" {
  display_name = "${var.folder_prefix}-${local.env}"
  parent       = local.parent_id
}

/******************************************
  VPC Host Projects
*****************************************/

data "google_projects" "base_host_project" {
  filter = "parent.id:${split("/", data.google_active_folder.env.name)[1]} labels.application_name=base-shared-vpc-host labels.environment=${local.env} lifecycleState=ACTIVE"
}

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
  bgp_asn_subnet                = var.enable_partner_interconnect ? "16550" : "64514"
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
  allow_all_ingress_ranges      = local.enable_transitivity ? local.base_hub_subnet_ranges : null
  allow_all_egress_ranges       = local.enable_transitivity ? local.base_subnet_aggregates : null
}

/******************************************
 Secure Application Subnets
*****************************************/

resource "google_compute_subnetwork" "base_subnets_spoke" {
  for_each                 = local.subnets
  name                     = each.value.subnet_name
  ip_cidr_range            = each.value.subnet_ip
  region                   = each.value.subnet_region
  private_ip_google_access = lookup(each.value, "subnet_private_access", "false")
  dynamic "log_config" {
    for_each = lookup(each.value, "subnet_flow_logs", false) ? [{
      aggregation_interval = lookup(each.value, "subnet_flow_logs_interval", "INTERVAL_5_SEC")
      flow_sampling        = lookup(each.value, "subnet_flow_logs_sampling", "0.5")
      metadata             = lookup(each.value, "subnet_flow_logs_metadata", "INCLUDE_ALL_METADATA")
    }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
    }
  }
  network     = module.base_shared_vpc.network_self_link
  project     = local.base_project_id
  description = lookup(each.value, "description", null)
  secondary_ip_range = [
    for i in range(
      length(
        contains(
        keys(var.secondary_ranges), each.value.subnet_name) == true
        ? var.secondary_ranges[each.value.subnet_name]
        : []
    )) :
    var.secondary_ranges[each.value.subnet_name][i]
  ]
}

/******************************************
 VPC firewall rules
*****************************************/

locals {
  boa_gke1_cluster_cidr = var.boa_gke1_cluster_cidr
  boa_gke2_cluster_cidr = var.boa_gke2_cluster_cidr
  boa_mci_cluster_cidr  = var.boa_mci_cluster_cidr
}

resource "google_compute_firewall" "allow_lb_healthcheck" {
  name      = "fw-${var.environment_code}-shared-base-allow-lb-healthcheck"
  project   = local.base_project_id
  network   = module.base_shared_vpc.network_self_link
  priority  = 1000
  direction = "INGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges           = ["0.0.0.0/0", "0.0.0.0/0"]
  target_service_accounts = ["tf-gke-gke-boa-us-east-huj0@prj-bu1-d-boa-gke-ecb0.iam.gserviceaccount.com"]

  allow {
    protocol = "tcp"
    ports    = ["443", "10250", "15017"]
  }
}

resource "google_compute_firewall" "allow_asm_healthcheck_sidecar_east" {
  name      = "fw-${var.environment_code}-shared-base-allow-asm-healthcheck-autosidecar-east"
  project   = local.base_project_id
  network   = module.base_shared_vpc.network_self_link
  priority  = 1000
  direction = "INGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gke-gke-boa-us-east1-001-1d5c9eff-node"]

  allow {
    protocol = "tcp"
    ports    = ["443", "10250", "15017"]
  }
}

resource "google_compute_firewall" "allow_asm_healthcheck_sidecar_west" {
  name      = "fw-${var.environment_code}-shared-base-allow-asm-healthcheck-autosidecar-west"
  project   = local.base_project_id
  network   = module.base_shared_vpc.network_self_link
  priority  = 1000
  direction = "INGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gke-gke-boa-us-west1-001-20e58b91-node"]

  allow {
    protocol = "tcp"
    ports    = ["443", "10250", "15017"]
  }
}

resource "google_compute_firewall" "temp_allow_8443_opa_east" {
  name      = "fw-${var.environment_code}-shared-base-temp-allow-8443-east"
  project   = local.base_project_id
  network   = module.base_shared_vpc.network_self_link
  priority  = 1000
  direction = "INGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gke-gke-boa-us-east1-001-1d5c9eff-node"]

  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }
}

resource "google_compute_firewall" "temp_allow_8443_opa_west" {
  name      = "fw-${var.environment_code}-shared-base-temp-allow-8443-opa-west"
  project   = local.base_project_id
  network   = module.base_shared_vpc.network_self_link
  priority  = 1000
  direction = "INGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gke-gke-boa-us-west1-001-20e58b91-node"]

  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }
}

resource "google_compute_firewall" "temp_allow_pod_east_west" {
  name      = "fw-${var.environment_code}-shared-base-temp-allow-pod-east-west"
  project   = local.base_project_id
  network   = module.base_shared_vpc.network_self_link
  priority  = 1000
  direction = "INGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gke-gke-boa-us-west1-001-20e58b91-node"]

  allow {
    protocol = "tcp"
    ports    = ["443", "8080"]
  }
}

resource "google_compute_firewall" "temp_allow_pod_west_east" {
  name      = "fw-${var.environment_code}-shared-base-temp-allow-8443-opa-west-east"
  project   = local.base_project_id
  network   = module.base_shared_vpc.network_self_link
  priority  = 1000
  direction = "INGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gke-gke-boa-us-east1-001-1d5c9eff-node"]

  allow {
    protocol = "tcp"
    ports    = ["443", "8080"]
  }
}

resource "google_compute_firewall" "temp_allow_asm_install" {
  name      = "fw-${var.environment_code}-temp-allow-asm-install"
  project   = local.base_project_id
  network   = module.base_shared_vpc.network_self_link
  priority  = 1000
  direction = "INGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gke-gke-boa-us-east1-001-1d5c9eff-node", "gke-gke-boa-us-west1-001-20e58b91-node"]

  allow {
    protocol = "all"
    ports    = ["all"]
  }
}

resource "google_compute_firewall" "gke1_allow_master_cidr" {
  name      = "fw-${var.environment_code}-shared-base-e-gke1-allow-master-cidr"
  network   = module.base_shared_vpc.network_self_link
  project   = local.base_project_id
  direction = "EGRESS"
  priority  = 900

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  allow {
    protocol = "tcp"
    ports    = ["443", "10250"]
  }

  destination_ranges = [local.boa_gke1_cluster_cidr]
  target_tags        = ["boa-gke1-cluster"]
}

resource "google_compute_firewall" "gke2_allow_master_cidr" {
  name      = "fw-${var.environment_code}-shared-base-e-gke2-allow-master-cidr"
  network   = module.base_shared_vpc.network_self_link
  project   = local.base_project_id
  direction = "EGRESS"
  priority  = 900

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  allow {
    protocol = "tcp"
    ports    = ["443", "10250"]
  }

  destination_ranges = [local.boa_gke2_cluster_cidr]
  target_tags        = ["boa-gke2-cluster"]
}

resource "google_compute_firewall" "mci_allow_master_cidr" {
  name      = "fw-${var.environment_code}-shared-base-e-mci-allow-master-cidr"
  network   = module.base_shared_vpc.network_self_link
  project   = local.base_project_id
  direction = "EGRESS"
  priority  = 900

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  allow {
    protocol = "tcp"
    ports    = ["443", "10250"]
  }

  destination_ranges = [local.boa_mci_cluster_cidr]
  target_tags        = ["boa-mci-cluster"]
}

/******************************************
 Cloud Armor policy
*****************************************/

resource "google_compute_security_policy" "cloud-armor-xss-policy" {
  name    = var.policy_name
  project = local.base_project_id
  rule {
    action   = var.policy_action
    priority = var.policy_priority
    match {
      expr {
        expression = var.policy_expression
      }
    }
    description = var.policy_description
  }

}

/******************************************
 Private services access range for Cloud SQL
*****************************************/

resource "google_compute_global_address" "private_service_access_address" {
  name          = var.private_service_address_name
  project       = local.base_project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = element(split("/", local.base_private_service_cidr), 0)
  prefix_length = element(split("/", local.base_private_service_cidr), 1)
  network       = module.base_shared_vpc.network_self_link
}

/******************************************
 External IP Address
*****************************************/

resource "google_compute_address" "external_ip_for_http_load_balancing" {
  name         = var.address_name
  project      = local.base_project_id
  address_type = var.address_type
  description  = var.description
  region       = var.region
}
