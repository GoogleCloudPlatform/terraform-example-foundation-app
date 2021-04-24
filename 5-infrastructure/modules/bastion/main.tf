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

data "google_compute_network" "vpc" {
  project = var.network_project_id
  name    = var.vpc_name
}

data "google_compute_subnetwork" "bastion_subnet" {
  project = var.network_project_id
  name    = var.bastion_subnet
  region  = var.bastion_region
}

module "iap_bastion" {
  source  = "terraform-google-modules/bastion-host/google"
  version = "~> 3.1"
  project = var.project_id

  # Variables for existing network
  network      = data.google_compute_network.vpc.self_link
  subnet       = data.google_compute_subnetwork.bastion_subnet.self_link
  host_project = var.network_project_id

  # Customizable Variables
  name                 = var.bastion_name
  zone                 = var.bastion_zone
  service_account_name = var.bastion_service_account_name
  service_account_roles_supplemental = [
    "roles/compute.admin",
    "roles/gkehub.admin",
    "roles/container.admin",
    "roles/meshconfig.admin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/servicemanagement.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/privateca.admin"
  ]
  create_firewall_rule = false
  shielded_vm          = false
  members              = var.bastion_members
  tags                 = ["bastion", "allow-google-apis", "egress-internet"]
}

resource "google_project_iam_member" "bastion_repo_access" {
  project = var.repo_project_id
  role    = "roles/source.writer"
  member  = "serviceAccount:${module.iap_bastion.service_account}"
}
