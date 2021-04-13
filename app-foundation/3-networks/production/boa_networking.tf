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
  boa_gke_cluster1_master_cidr = "100.64.206.0/28"
  boa_gke_cluster2_master_cidr = "100.65.198.0/28"
  boa_gke_mci_master_cidr      = "100.64.198.0/28"
}

/******************************************
 VPC firewall rules
*****************************************/

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

  source_ranges = ["172.16.2.0/28"]
  target_tags   = ["boa-gke1-cluster"]

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

  source_ranges = ["172.16.0.16/28"]
  target_tags   = ["boa-gke2-cluster"]

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

  source_ranges = ["172.16.2.0/28"]
  target_tags   = ["boa-gke1-cluster"]

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

  source_ranges = ["172.16.2.0/28"]
  target_tags   = ["boa-gke2-cluster"]

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

  source_ranges = ["100.64.200.0/22"]
  target_tags   = ["boa-gke2-cluster"]

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

  source_ranges = ["100.65.192.0/22"]
  target_tags   = ["boa-gke1-cluster"]

  allow {
    protocol = "tcp"
    ports    = ["443", "8080"]
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

  destination_ranges = [local.boa_gke_cluster1_master_cidr]
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

  destination_ranges = [local.boa_gke_cluster2_master_cidr]
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

  destination_ranges = [local.boa_gke_mci_master_cidr]
  target_tags        = ["boa-mci-cluster"]
}

/******************************************
 Private services address for Cloud SQL
*****************************************/

resource "google_compute_global_address" "private_services_address" {
  name          = "cloud-sql-subnet-vpc-peering-internal"
  project       = local.base_project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = element(split("/", local.base_private_service_cidr), 0)
  prefix_length = element(split("/", local.base_private_service_cidr), 1)
  network       = module.base_shared_vpc.network_self_link
}
