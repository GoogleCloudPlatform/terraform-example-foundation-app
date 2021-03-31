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

module "private-cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version = "13.1.0"

  # Variables controlling BOA setup modifiable
  # by environment/end-user
  project_id             = var.project_id
  region                 = var.region
  name                   = var.cluster_name
  network                = var.network_name
  subnetwork             = var.subnetwork_name
  network_project_id     = var.network_project_id
  ip_range_pods          = var.range_name_pods
  ip_range_services      = var.range_name_services
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  node_pools             = var.node_pools

  # Opinionated variables
  enable_private_endpoint = true
  grant_registry_access   = true
  http_load_balancing     = true
  release_channel         = "REGULAR"
  enable_shielded_nodes   = true

  # Set master authorized network to the bastion
  # subnet
  master_authorized_networks = var.master_authorized_networks
}
