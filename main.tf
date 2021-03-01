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
  cluster_name             = "test-cluster-svpc"
  bastion_name             = format("%s-bastion", local.cluster_name)
  bastion_zone             = format("%s-a", var.region)
  cluster_secondary_ranges = [for secondary in data.google_compute_subnetwork.subnetwork.secondary_ip_range : secondary.ip_cidr_range]
  cluster_ip_ranges        = concat([var.master_ipv4_cidr_block, data.google_compute_subnetwork.subnetwork.ip_cidr_range], local.cluster_secondary_ranges)
}

# bastion host
data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  EOF
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  project = var.network_project_id
  region  = var.region
}

module "bastion" {
  source         = "terraform-google-modules/bastion-host/google"
  version        = "~> 2.0"
  network        = var.network
  subnet         = data.google_compute_subnetwork.subnetwork.self_link
  project        = var.project_id
  host_project   = var.network_project_id
  name           = local.bastion_name
  zone           = local.bastion_zone
  image_project  = "debian-cloud"
  image_family   = "debian-9"
  machine_type   = "g1-small"
  startup_script = data.template_file.startup_script.rendered
  members        = [var.bastion_member]
  shielded_vm    = "false"
  tags           = ["allow-iap-ssh", "egress-internet"]
}

# fw for bastion packages
resource "google_compute_firewall" "bastion-fw" {
  name      = "bastion-fw"
  network   = var.network
  project   = var.network_project_id
  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  target_service_accounts = [module.bastion.service_account]
}

# FW rule to allow network load balancer for hipster shop
resource "google_compute_firewall" "lb-fw" {
  name          = "lb-fw"
  network       = var.network
  project       = var.network_project_id
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  enable_logging = true

  target_service_accounts = [google_service_account.node-sa.email]
}

# Egress between nodes in cluster
# TODO: reduce the ranges here after testing
resource "google_compute_firewall" "intracluster-fw" {
  name      = "intracluster-egress"
  network   = var.network
  project   = var.network_project_id
  direction = "EGRESS"

  destination_ranges = local.cluster_ip_ranges

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  enable_logging = true

  target_service_accounts = [google_service_account.node-sa.email]
}

# node sa
resource "google_service_account" "node-sa" {
  project      = var.project_id
  account_id   = "node-sa"
  display_name = "node-sa"
}

# gke
module "gke-dev-9" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version                    = "~> 10.0"
  project_id                 = var.project_id
  name                       = local.cluster_name
  region                     = var.region
  network_project_id         = var.network_project_id
  network                    = var.network
  subnetwork                 = var.subnetwork
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  create_service_account     = false
  service_account            = google_service_account.node-sa.email
  add_cluster_firewall_rules = true
  enable_private_endpoint    = true
  enable_private_nodes       = true
  master_authorized_networks = [{
    cidr_block   = "${module.bastion.ip_address}/32"
    display_name = "Bastion Host"
  }]
}