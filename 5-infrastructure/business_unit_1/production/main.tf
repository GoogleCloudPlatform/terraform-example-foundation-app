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

module "env" {
  source = "../../modules/base-env"
  env    = "prd"

  terraform_service_account    = var.terraform_service_account
  location_primary             = var.location_primary
  location_secondary           = var.location_secondary
  gcp_shared_vpc_project_id    = var.gcp_shared_vpc_project_id
  shared_vpc_name              = var.shared_vpc_name
  boa_gke_project_id           = var.boa_gke_project_id
  boa_ops_project_id           = var.boa_ops_project_id
  boa_sec_project_id           = var.boa_sec_project_id
  boa_sql_project_id           = var.boa_sql_project_id
  gke_cluster_1_cidr_block     = "100.64.206.0/28" # Cluster control plane same is defined in 3-networks/envs/production/boa_vpc_fw.tf
  gke_cluster_2_cidr_block     = "100.65.198.0/28" # Cluster control plane same is defined in 3-networks/envs/production/boa_vpc_fw.tf
  gke_mci_cluster_cidr_block   = "100.64.198.0/28" # Cluster control plane same is defined in 3-networks/envs/production/boa_vpc_fw.tf
  bastion_members              = var.bastion_members
  enforce_bin_auth_policy      = var.enforce_bin_auth_policy
  bin_auth_attestor_names      = var.bin_auth_attestor_names
  bin_auth_attestor_project_id = var.bin_auth_attestor_project_id
  sql_admin_username           = var.sql_admin_username
  sql_admin_password           = var.sql_admin_password
}
