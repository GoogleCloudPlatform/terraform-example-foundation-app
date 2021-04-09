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
 VPC firewall rules
*****************************************/

locals {
  boa_gke_cluster1_master_cidr = "100.64.78.0/28"
  boa_gke_cluster2_master_cidr = "100.65.70.0/28"
  boa_gke_mci_master_cidr      = "100.64.70.0/28"
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

  source_ranges           = ["35.191.0.0/16", "130.211.0.0/22"]
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

  source_ranges = ["172.16.2.0/28"]
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

  source_ranges = ["172.16.0.16/28"]
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

  source_ranges = ["172.16.2.0/28"]
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

  source_ranges = ["172.16.2.0/28"]
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

  source_ranges = ["100.64.72.0/22"]
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

  source_ranges = ["100.65.64.0/22"]
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
