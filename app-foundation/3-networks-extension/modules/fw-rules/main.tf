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
  ingress_rules = {
    "fw-${var.environment_code}-shared-base-allow-asm-healthcheck-autosidecar" = {
      source_ranges  = [var.boa_gke_cluster1_master_cidr, var.boa_gke_cluster2_master_cidr]
      target_tags    = ["boa-gke1-cluster", "boa-gke2-cluster"]
      allow_protocol = "tcp"
      allow_ports    = ["443", "10250", "15017"]
    },
    "fw-${var.environment_code}-shared-base-allow-8443-opa" = {
      source_ranges  = [var.boa_gke_cluster1_master_cidr, var.boa_gke_cluster2_master_cidr]
      target_tags    = ["boa-gke1-cluster", "boa-gke2-cluster"]
      allow_protocol = "tcp"
      allow_ports    = ["8443"]
    },
    "fw-${var.environment_code}-shared-base-allow-pod-east-west" = {
      source_ranges  = ["100.64.72.0/22"]
      target_tags    = ["boa-gke2-cluster"]
      allow_protocol = "tcp"
      allow_ports    = ["443", "8080"]
    },
    "fw-${var.environment_code}-shared-base-allow-pod-west-east" = {
      source_ranges  = ["100.65.64.0/22"]
      target_tags    = ["boa-gke1-cluster"]
      allow_protocol = "tcp"
      allow_ports    = ["443", "8080"]
    }
  }
  egress_rules = {
    "fw-${var.environment_code}-shared-base-e-gke1-allow-master-cidr" = {
      destination_ranges = [var.boa_gke_cluster1_master_cidr]
      target_tags        = ["boa-gke1-cluster"]
      allow_protocol     = "tcp"
      allow_ports        = ["443", "10250"]
    },
    "fw-${var.environment_code}-shared-base-e-gke2-allow-master-cidr" = {
      destination_ranges = [var.boa_gke_cluster2_master_cidr]
      target_tags        = ["boa-gke2-cluster"]
      allow_protocol     = "tcp"
      allow_ports        = ["443", "10250"]
    },
    "fw-${var.environment_code}-shared-base-e-mci-allow-master-cidr" = {
      destination_ranges = [var.boa_gke_mci_master_cidr]
      target_tags        = ["boa-mci-cluster"]
      allow_protocol     = "tcp"
      allow_ports        = ["443", "10250"]
    },
    "fw-${var.environment_code}-shared-base-e-bastion-allow-all" = {
      destination_ranges = ["0.0.0.0/0"]
      target_tags        = ["bastion"]
      allow_protocol     = "all"
      allow_ports        = null
    }
  }
}

/******************************************
 VPC firewall rules
*****************************************/

resource "google_compute_firewall" "fw_ingress_rules" {
  for_each  = local.ingress_rules
  name      = each.key
  project   = var.fw_project_id
  network   = var.network_link
  priority  = 1000
  direction = "INGRESS"
  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{ metadata = "INCLUDE_ALL_METADATA" }] : []
    content {
      metadata = log_config.value.metadata
    }
  }
  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags
  allow {
    protocol = each.value.allow_protocol
    ports    = each.value.allow_ports
  }
}

resource "google_compute_firewall" "fw_egress_rules" {
  for_each  = local.egress_rules
  name      = each.key
  network   = var.network_link
  project   = var.fw_project_id
  direction = "EGRESS"
  priority  = 900
  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{ metadata = "INCLUDE_ALL_METADATA" }] : []
    content {
      metadata = log_config.value.metadata
    }
  }
  allow {
    protocol = each.value.allow_protocol
    ports    = each.value.allow_ports
  }
  destination_ranges = each.value.destination_ranges
  target_tags        = each.value.target_tags
}
