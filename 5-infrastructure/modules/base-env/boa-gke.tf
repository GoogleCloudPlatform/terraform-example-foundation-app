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
  gke_settings = {
    cluster_1 = {
      name                   = "gke-boa-${var.location_primary}-001"
      subnetwork             = var.gke_cluster_1_subnet_name
      ip_range_pods          = var.gke_cluster_1_range_name_pods
      ip_range_services      = var.gke_cluster_1_range_name_services
      master_ipv4_cidr_block = var.gke_cluster_1_cidr_block
      region                 = var.location_primary
      machine_type           = "e2-standard-4"
      master_authorized_networks = [
        {
          cidr_block   = element([for subnet_ip_range in flatten([for subnet in data.google_compute_subnetwork.subnet : subnet.secondary_ip_range if length(subnet.secondary_ip_range) > 0 && subnet.name == var.gke_cluster_2_subnet_name]) : subnet_ip_range.ip_cidr_range if subnet_ip_range.range_name == var.gke_cluster_2_range_name_pods], 0),
          display_name = var.gke_cluster_2_range_name_pods
        }
      ]
    },
    cluster_2 = {
      name                   = "gke-boa-${var.location_secondary}-001"
      subnetwork             = var.gke_cluster_2_subnet_name
      ip_range_pods          = var.gke_cluster_2_range_name_pods
      ip_range_services      = var.gke_cluster_2_range_name_services
      master_ipv4_cidr_block = var.gke_cluster_2_cidr_block
      region                 = var.location_secondary
      machine_type           = "e2-standard-4"
      master_authorized_networks = [
        {
          cidr_block   = element([for subnet_ip_range in flatten([for subnet in data.google_compute_subnetwork.subnet : subnet.secondary_ip_range if length(subnet.secondary_ip_range) > 0 && subnet.name == var.gke_cluster_1_subnet_name]) : subnet_ip_range.ip_cidr_range if subnet_ip_range.range_name == var.gke_cluster_1_range_name_pods], 0),
          display_name = var.gke_cluster_1_range_name_pods
        }
      ]
    },
    mci_cluster = {
      name                       = "gke-mci-${var.location_primary}-001"
      subnetwork                 = var.gke_mci_cluster_subnet_name
      ip_range_pods              = var.gke_mci_cluster_range_name_pods
      ip_range_services          = var.gke_mci_cluster_range_name_services
      master_ipv4_cidr_block     = var.gke_mci_cluster_cidr_block
      region                     = var.location_primary
      machine_type               = "e2-standard-2"
      master_authorized_networks = []
    }
  }
}

module "sink_gke" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 5.2"
  destination_uri        = module.log_destination.destination_uri
  filter                 = "resource.type:(k8s_cluster OR k8s_container OR gce_target_https_proxy OR gce_url_map OR http_load_balancer OR gce_target_https_proxy OR gce_backend_service OR gce_instance OR gce_forwarding_rule OR gce_health_check OR service_account OR global OR audited_resource OR project)"
  log_sink_name          = "sink-boa-gke-${local.envs[var.env].short}-01"
  parent_resource_id     = var.boa_gke_project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "bastion" {
  source                       = "../bastion"
  project_id                   = var.boa_gke_project_id
  bastion_name                 = "gce-bastion-${lower(var.bastion_zone)}-01"
  bastion_zone                 = var.bastion_zone
  bastion_service_account_name = "gce-bastion-${local.envs[var.env].short}-boa-sa"
  bastion_members              = var.bastion_members
  vpc_name                     = "vpc-${var.env}-shared-base"
  bastion_subnet               = var.bastion_subnet_name
  bastion_region               = var.location_secondary
  network_project_id           = var.gcp_shared_vpc_project_id
}

module "clusters" {
  source   = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version  = "~> 14.0"
  for_each = local.gke_settings

  project_id         = var.boa_gke_project_id
  network_project_id = var.gcp_shared_vpc_project_id
  network            = "vpc-${var.env}-shared-base"

  name                   = each.value.name
  subnetwork             = each.value.subnetwork
  ip_range_pods          = each.value.ip_range_pods
  ip_range_services      = each.value.ip_range_services
  master_ipv4_cidr_block = each.value.master_ipv4_cidr_block
  region                 = each.value.region
  master_authorized_networks = concat(each.value.master_authorized_networks,
    [
      {
        cidr_block   = module.bastion.cidr_range,
        display_name = module.bastion.subnet_name
      }
    ]
  )
  node_pools = [
    {
      name               = "np-${each.value.region}-01",
      auto_repair        = true,
      auto_upgrade       = true,
      enable_secure_boot = true,
      image_type         = "COS_CONTAINERD",
      machine_type       = each.value.machine_type,
      max_count          = 3,
      min_count          = 1,
      node_metadata      = "GKE_METADATA_SERVER"
    }
  ]
}
