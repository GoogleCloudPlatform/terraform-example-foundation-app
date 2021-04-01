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

module "sink_gke" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 5.2"
  destination_uri        = module.log_destination.destination_uri
  filter                 = "resource.type:(k8s_cluster OR k8s_container OR gce_target_https_proxy OR gce_url_map OR http_load_balancer OR gce_target_https_proxy OR gce_backend_service OR gce_instance OR gce_forwarding_rule OR gce_health_check OR service_account OR global OR audited_resource OR project)"
  log_sink_name          = "sink-boa-gke-01"
  parent_resource_id     = var.boa_gke_project_id != "" ? var.boa_gke_project_id : local.auto_gke_project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "bastion" {
  source                       = "../bastion"
  project_id                   = var.boa_gke_project_id != "" ? var.boa_gke_project_id : local.auto_gke_project_id
  bastion_name                 = "gce-bastion-${lower(var.bastion_zone)}-01"
  bastion_zone                 = var.bastion_zone
  bastion_service_account_name = "gce-bastion-${var.environment_code}-boa-sa"
  bastion_members              = var.bastion_members
  vpc_name                     = "vpc-${var.env_short}-shared-base"
  bastion_subnet               = var.bastion_subnet_name
  bastion_region               = var.location_secondary != "" ? var.location_secondary : var.bastion_subnet_region
  network_project_id           = var.gcp_shared_vpc_project_id != "" ? var.gcp_shared_vpc_project_id : local.auto_shared_vpc_project_id
}

module "cluster_1" {
  source                 = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version                = "~> 14.0"
  name                   = "gke-boa-${var.location_primary != "" ? var.location_primary : var.gke_cluster_1_location}-001"
  network                = "vpc-${var.env_short}-shared-base"
  subnetwork             = var.gke_cluster_1_subnet_name
  network_project_id     = var.gcp_shared_vpc_project_id != "" ? var.gcp_shared_vpc_project_id : local.auto_shared_vpc_project_id
  ip_range_pods          = var.gke_cluster_1_range_name_pods
  ip_range_services      = var.gke_cluster_1_range_name_services
  master_ipv4_cidr_block = var.gke_cluster_1_cidr_block
  project_id             = var.boa_gke_project_id != "" ? var.boa_gke_project_id : local.auto_gke_project_id
  region                 = var.location_primary != "" ? var.location_primary : var.gke_cluster_1_location
  master_authorized_networks = [
    {
      cidr_block   = module.bastion.cidr_range,
      display_name = module.bastion.subnet_name
    }
  ]
  node_pools = [
    {
      name               = "np-${var.location_primary != "" ? var.location_primary : var.gke_cluster_1_location}-01",
      auto_repair        = true,
      auto_upgrade       = true,
      enable_secure_boot = true,
      image_type         = "COS_CONTAINERD",
      machine_type       = var.gke_cluster_1_machine_type,
      max_count          = 3,
      min_count          = 1,
      node_metadata      = "GKE_METADATA_SERVER"
    }
  ]
}

module "cluster_2" {
  source                 = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version                = "~> 14.0"
  name                   = "gke-boa-${var.location_secondary != "" ? var.location_secondary : var.gke_cluster_2_location}-001"
  network                = "vpc-${var.env_short}-shared-base"
  subnetwork             = var.gke_cluster_2_subnet_name
  network_project_id     = var.gcp_shared_vpc_project_id != "" ? var.gcp_shared_vpc_project_id : local.auto_shared_vpc_project_id
  ip_range_pods          = var.gke_cluster_2_range_name_pods
  ip_range_services      = var.gke_cluster_2_range_name_services
  master_ipv4_cidr_block = var.gke_cluster_2_cidr_block
  project_id             = var.boa_gke_project_id != "" ? var.boa_gke_project_id : local.auto_gke_project_id
  region                 = var.location_secondary != "" ? var.location_secondary : var.gke_cluster_2_location
  master_authorized_networks = [
    {
      cidr_block   = module.bastion.cidr_range,
      display_name = module.bastion.subnet_name
    }
  ]
  node_pools = [
    {
      name               = "np-${var.location_secondary != "" ? var.location_secondary : var.gke_cluster_2_location}-01",
      auto_repair        = true,
      auto_upgrade       = true,
      enable_secure_boot = true,
      image_type         = "COS_CONTAINERD",
      machine_type       = var.gke_cluster_2_machine_type,
      max_count          = 3,
      min_count          = 1,
      node_metadata      = "GKE_METADATA_SERVER"
    }
  ]
}

module "mci_cluster" {
  source                 = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version                = "~> 14.0"
  name                   = "gke-mci-${var.location_primary != "" ? var.location_primary : var.gke_mci_cluster_location}-001"
  network                = "vpc-${var.env_short}-shared-base"
  subnetwork             = var.gke_mci_cluster_subnet_name
  network_project_id     = var.gcp_shared_vpc_project_id != "" ? var.gcp_shared_vpc_project_id : local.auto_shared_vpc_project_id
  ip_range_pods          = var.gke_mci_cluster_range_name_pods
  ip_range_services      = var.gke_mci_cluster_range_name_services
  master_ipv4_cidr_block = var.gke_mci_cluster_cidr_block
  project_id             = var.boa_gke_project_id != "" ? var.boa_gke_project_id : local.auto_gke_project_id
  region                 = var.location_primary != "" ? var.location_primary : var.gke_mci_cluster_location
  master_authorized_networks = [
    {
      cidr_block   = module.bastion.cidr_range,
      display_name = module.bastion.subnet_name
    }
  ]
  node_pools = [
    {
      name               = "np-${var.location_primary != "" ? var.location_primary : var.gke_mci_cluster_location}-01",
      auto_repair        = true,
      auto_upgrade       = true,
      enable_secure_boot = true,
      image_type         = "COS_CONTAINERD",
      machine_type       = var.gke_mci_cluster_machine_type,
      max_count          = 3,
      min_count          = 1,
      node_metadata      = "GKE_METADATA_SERVER"
    }
  ]
}
