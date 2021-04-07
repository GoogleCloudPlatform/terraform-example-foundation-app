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

module "boa_secret_project" {
  source                      = "github.com/terraform-google-modules/terraform-example-foundation/4-projects/modules/single_project"
  impersonate_service_account = var.terraform_service_account
  org_id                      = var.org_id
  billing_account             = var.billing_account
  folder_id                   = data.google_active_folder.env.name
  environment                 = "development"
  vpc_type                    = "base"
  enable_hub_and_spoke        = var.enable_hub_and_spoke
  alert_spent_percents        = var.alert_spent_percents
  alert_pubsub_topic          = var.alert_pubsub_topic
  budget_amount               = var.budget_amount
  project_prefix              = var.project_prefix
  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudkms.googleapis.com",
    "secretmanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "logging.googleapis.com",
    "storage-api.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com"
  ]

  # Metadata
  project_suffix    = "boa-sec"
  application_name  = "bu1-sample-application"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "bu1"
}

module "terraform_deployment_sa" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 3.0"
  project_id = module.boa_secret_project.project_id
  names      = ["boa-terraform-${var.environment_code}-sa"]
  project_roles = [
    "${module.boa_gke_project.project_id}=>roles/compute.viewer",
    "${module.boa_gke_project.project_id}=>roles/compute.instanceAdmin.v1",
    "${module.boa_gke_project.project_id}=>roles/container.clusterAdmin",
    "${module.boa_gke_project.project_id}=>roles/container.developer",
    "${module.boa_gke_project.project_id}=>roles/viewer",
    "${module.boa_gke_project.project_id}=>roles/iam.serviceAccountAdmin",
    "${module.boa_gke_project.project_id}=>roles/iam.serviceAccountUser",
    "${module.boa_gke_project.project_id}=>roles/resourcemanager.projectIamAdmin",
    "${module.boa_gke_project.project_id}=>roles/logging.configWriter",
    "${module.boa_gke_project.project_id}=>roles/storage.objectViewer",
    "${module.boa_gke_project.project_id}=>roles/iap.admin",
    "${module.boa_gke_project.project_id}=>roles/iam.roleAdmin",
    "${module.boa_ops_project.project_id}=>roles/logging.configWriter",
    "${module.boa_ops_project.project_id}=>roles/serviceusage.serviceUsageAdmin",
    "${module.boa_ops_project.project_id}=>roles/resourcemanager.projectIamAdmin",
    "${module.boa_ops_project.project_id}=>roles/storage.admin",
    "${module.boa_secret_project.project_id}=>roles/cloudkms.admin",
    "${module.boa_secret_project.project_id}=>roles/logging.configWriter",
    "${module.boa_secret_project.project_id}=>roles/iam.serviceAccountCreator",
    "${module.boa_secret_project.project_id}=>roles/secretmanager.admin",
    "${module.boa_sql_project.project_id}=>roles/cloudsql.admin",
    "${module.boa_sql_project.project_id}=>roles/compute.networkAdmin",
    "${module.boa_sql_project.project_id}=>roles/logging.configWriter",
    "${var.shared_vpc_host_project_id}=>roles/compute.networkAdmin",
    "${var.shared_vpc_host_project_id}=>roles/compute.securityAdmin"
  ]
}

resource "google_service_account_iam_member" "cloudbuild_terraform_sa_impersonate_permissions" {
  service_account_id = module.terraform_deployment_sa.service_account.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${var.app_infra_pipeline_cloudbuild_sa}"
}

data "google_projects" "shared_vpc_project" {
  filter = "name:${var.project_prefix}-${var.environment_code}-shared-base"
}

data "google_compute_network" "vpc" {
  project = var.shared_vpc_host_project_id
  name    = var.shared_vpc_network_name
}

data "google_compute_subnetwork" "subnet" {
  for_each  = toset(data.google_compute_network.vpc.subnetworks_self_links)
  self_link = each.value
}

resource "google_compute_subnetwork_iam_member" "terraform_subnet_member" {
  for_each   = data.google_compute_subnetwork.subnet
  project    = each.value.project
  region     = each.value.region
  subnetwork = each.value.name
  role       = "roles/compute.networkUser"
  member     = module.terraform_deployment_sa.iam_email
}

resource "google_compute_subnetwork_iam_member" "gke_subnet_member" {
  for_each   = data.google_compute_subnetwork.subnet
  project    = each.value.project
  region     = each.value.region
  subnetwork = each.value.name
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:service-${module.boa_gke_project.project_number}@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_compute_subnetwork_iam_member" "gke_nodes_subnet_member" {
  for_each   = data.google_compute_subnetwork.subnet
  project    = each.value.project
  region     = each.value.region
  subnetwork = each.value.name
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${module.boa_gke_project.project_number}@cloudservices.gserviceaccount.com"
}
