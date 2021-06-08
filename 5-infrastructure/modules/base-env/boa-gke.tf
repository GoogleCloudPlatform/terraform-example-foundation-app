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
    gke1 = {
      name                      = "gke-1-boa-${local.envs[var.env].short}-${var.location_primary}"
      subnetwork                = var.gke_cluster_1_subnet_name
      ip_range_pods             = var.gke_cluster_1_range_name_pods
      ip_range_services         = var.gke_cluster_1_range_name_services
      master_ipv4_cidr_block    = var.gke_cluster_1_cidr_block
      default_max_pods_per_node = var.max_pods_per_node
      region                    = var.location_primary
      node_pool_min_count       = 2
      node_pool_max_count       = 3
      machine_type              = "e2-standard-4"
      master_authorized_networks = [
        {
          cidr_block   = element([for subnet_ip_range in flatten([for subnet in data.google_compute_subnetwork.subnet : subnet.secondary_ip_range if length(subnet.secondary_ip_range) > 0 && subnet.name == var.gke_cluster_2_subnet_name]) : subnet_ip_range.ip_cidr_range if subnet_ip_range.range_name == var.gke_cluster_2_range_name_pods], 0)
          display_name = "cluster 2 pods to cluster 1 controlplane"
        }
      ]
    },
    gke2 = {
      name                      = "gke-2-boa-${local.envs[var.env].short}-${var.location_secondary}"
      subnetwork                = var.gke_cluster_2_subnet_name
      ip_range_pods             = var.gke_cluster_2_range_name_pods
      ip_range_services         = var.gke_cluster_2_range_name_services
      master_ipv4_cidr_block    = var.gke_cluster_2_cidr_block
      default_max_pods_per_node = var.max_pods_per_node
      region                    = var.location_secondary
      machine_type              = "e2-standard-4"
      node_pool_min_count       = 2
      node_pool_max_count       = 3
      master_authorized_networks = [
        {
          cidr_block   = element([for subnet_ip_range in flatten([for subnet in data.google_compute_subnetwork.subnet : subnet.secondary_ip_range if length(subnet.secondary_ip_range) > 0 && subnet.name == var.gke_cluster_1_subnet_name]) : subnet_ip_range.ip_cidr_range if subnet_ip_range.range_name == var.gke_cluster_1_range_name_pods], 0)
          display_name = "cluster 1 pods to cluster 2 controlplane"
        }
      ]
    },
    mci = {
      name                       = "mci-boa-${local.envs[var.env].short}-${var.location_primary}"
      subnetwork                 = var.gke_mci_cluster_subnet_name
      ip_range_pods              = var.gke_mci_cluster_range_name_pods
      ip_range_services          = var.gke_mci_cluster_range_name_services
      master_ipv4_cidr_block     = var.gke_mci_cluster_cidr_block
      default_max_pods_per_node  = var.max_pods_per_node
      region                     = var.location_primary
      machine_type               = "e2-standard-2"
      node_pool_min_count        = 1
      node_pool_max_count        = 3
      master_authorized_networks = []
    }
  }
  bin_auth_attestors = [for attestor in var.bin_auth_attestor_names : "projects/${var.bin_auth_attestor_project_id}/attestors/${attestor}"]
  allowlist_patterns = ["quay.io/random-containers/*", "k8s.gcr.io/more-random/*", "gcr.io/${var.boa_gke_project_id}/*", "gcr.io/config-management-release/*"] # Example
}

module "sink_gke" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 6.0"
  destination_uri        = module.log_destination.destination_uri
  filter                 = "resource.type:(k8s_cluster OR k8s_container OR gce_target_https_proxy OR gce_url_map OR http_load_balancer OR gce_target_https_proxy OR gce_backend_service OR gce_instance OR gce_forwarding_rule OR gce_health_check OR service_account OR global OR audited_resource OR project)"
  log_sink_name          = "sink-boa-${local.envs[var.env].short}-gke-to-ops"
  parent_resource_id     = var.boa_gke_project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "bastion" {
  source                       = "../bastion"
  project_id                   = var.boa_gke_project_id
  bastion_name                 = "gce-bastion-${lower(var.bastion_zone)}-01"
  bastion_zone                 = var.bastion_zone
  bastion_service_account_name = "boa-gce-bastion-${local.envs[var.env].short}-sa"
  bastion_members              = var.bastion_members
  vpc_name                     = var.shared_vpc_name
  bastion_subnet               = var.bastion_subnet_name
  bastion_region               = var.location_secondary
  network_project_id           = var.gcp_shared_vpc_project_id
  repo_project_id              = var.bin_auth_attestor_project_id
}

data "google_project" "gke_project" {
  project_id = var.boa_gke_project_id
}

module "clusters" {
  source   = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version  = "~> 14.0.1"
  for_each = local.gke_settings

  project_id         = var.boa_gke_project_id
  network_project_id = var.gcp_shared_vpc_project_id
  network            = var.shared_vpc_name

  name                      = each.value.name
  subnetwork                = each.value.subnetwork
  ip_range_pods             = each.value.ip_range_pods
  ip_range_services         = each.value.ip_range_services
  master_ipv4_cidr_block    = each.value.master_ipv4_cidr_block
  default_max_pods_per_node = each.value.default_max_pods_per_node
  region                    = each.value.region
  master_authorized_networks = concat(each.value.master_authorized_networks,
    [
      {
        cidr_block   = module.bastion.cidr_range,
        display_name = "bastion subnet to cluster controlplane"
      }
    ]
  )
  cluster_resource_labels = {
    "mesh_id" = "proj-${data.google_project.gke_project.number}"
  }
  node_pools_tags = {
    "np-${each.value.region}" : ["boa-${each.key}-cluster", "allow-google-apis", "egress-internet", "boa-cluster", "allow-lb"]
  }
  node_pools = [
    {
      name               = "np-${each.value.region}",
      auto_repair        = true,
      auto_upgrade       = true,
      enable_secure_boot = true,
      image_type         = "COS_CONTAINERD",
      machine_type       = each.value.machine_type,
      max_count          = each.value.node_pool_max_count,
      min_count          = each.value.node_pool_min_count,
      node_metadata      = "GKE_METADATA_SERVER"
    }
  ]
  node_pools_oauth_scopes = {
    "all" : [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ],
    "default-node-pool" : []
  }
  compute_engine_service_account = "boa-gke-nodes-${local.envs[var.env].short}-gsa@${var.boa_gke_project_id}.iam.gserviceaccount.com"
}

resource "google_binary_authorization_policy" "policy" {
  project = var.boa_gke_project_id

  global_policy_evaluation_mode = "ENABLE"
  default_admission_rule {
    evaluation_mode         = "REQUIRE_ATTESTATION"
    enforcement_mode        = var.enforce_bin_auth_policy ? "ENFORCED_BLOCK_AND_AUDIT_LOG" : "DRYRUN_AUDIT_LOG_ONLY"
    require_attestations_by = local.bin_auth_attestors
  }
  dynamic "admission_whitelist_patterns" {
    for_each = local.allowlist_patterns
    content {
      name_pattern = admission_whitelist_patterns.value
    }
  }
}

/******************************************
 Cloud Armor policy
*****************************************/

resource "google_compute_security_policy" "cloud-armor-xss-policy" {
  name    = "cloud-armor-xss-policy"
  project = var.boa_gke_project_id
  rule {
    action   = "deny(403)"
    priority = "1000"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('xss-stable')"
      }
    }
    description = "Cloud Armor policy to prevent cross-site scripting attacks."
  }

  rule {
    action   = "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"
  }
}

/******************************************
 External IP Address
*****************************************/

resource "google_compute_global_address" "external_ip_for_http_load_balancing" {
  name         = "mci-ip"
  project      = var.boa_gke_project_id
  address_type = "EXTERNAL"
  description  = "External IP address for HTTP load balancing on MCI subnet."
}
