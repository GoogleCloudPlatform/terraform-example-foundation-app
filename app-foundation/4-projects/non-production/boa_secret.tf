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
  tf_deploy_sa_roles = {
    gke = [
      "roles/compute.viewer",
      "roles/compute.instanceAdmin.v1",
      "roles/container.clusterAdmin",
      "roles/container.developer",
      "roles/viewer",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountUser",
      "roles/resourcemanager.projectIamAdmin",
      "roles/logging.configWriter",
      "roles/storage.objectViewer",
      "roles/iap.admin",
      "roles/iam.roleAdmin",
      "roles/binaryauthorization.policyEditor",
      "roles/compute.securityAdmin",
      "roles/compute.publicIpAdmin"
    ],
    ops = [
      "roles/logging.configWriter",
      "roles/serviceusage.serviceUsageAdmin",
      "roles/resourcemanager.projectIamAdmin",
      "roles/storage.admin"
    ],
    sec = [
      "roles/cloudkms.admin",
      "roles/logging.configWriter",
      "roles/iam.serviceAccountCreator",
      "roles/secretmanager.admin"
    ],
    sql = [
      "roles/cloudsql.admin",
      "roles/compute.networkAdmin",
      "roles/logging.configWriter"
    ],
    vpc = [
      "roles/compute.networkAdmin",
      "roles/compute.securityAdmin"
    ],
    cicd = [
      "roles/binaryauthorization.attestorsViewer"
    ]
  }
}

module "boa_secret_project" {
  source                      = "github.com/terraform-google-modules/terraform-example-foundation/4-projects/modules/single_project"
  impersonate_service_account = var.terraform_service_account
  org_id                      = var.org_id
  billing_account             = var.billing_account
  folder_id                   = data.google_active_folder.env.name
  environment                 = "non-production"
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

resource "google_service_account" "boa_terraform_deployment_sa" {
  account_id  = "boa-terraform-${var.environment_code}-sa"
  description = "Service account to allow terraform to deploy 5-infra layer resources and services"
  project     = module.boa_secret_project.project_id
}

resource "google_service_account_iam_member" "cloudbuild_terraform_sa_impersonate_permissions" {
  service_account_id = google_service_account.boa_terraform_deployment_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${var.app_infra_pipeline_cloudbuild_sa}"
}

resource "google_project_iam_member" "boa_terraform_deployment_sa_roles_gke" {
  for_each = toset(local.tf_deploy_sa_roles.gke)
  project  = module.boa_gke_project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.boa_terraform_deployment_sa.email}"
}

resource "google_project_iam_member" "boa_terraform_deployment_sa_roles_sql" {
  for_each = toset(local.tf_deploy_sa_roles.sql)
  project  = module.boa_sql_project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.boa_terraform_deployment_sa.email}"
}

resource "google_project_iam_member" "boa_terraform_deployment_sa_roles_sec" {
  for_each = toset(local.tf_deploy_sa_roles.sec)
  project  = module.boa_secret_project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.boa_terraform_deployment_sa.email}"
}

resource "google_project_iam_member" "boa_terraform_deployment_sa_roles_ops" {
  for_each = toset(local.tf_deploy_sa_roles.ops)
  project  = module.boa_ops_project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.boa_terraform_deployment_sa.email}"
}

resource "google_project_iam_member" "boa_terraform_deployment_sa_roles_vpc" {
  for_each = toset(local.tf_deploy_sa_roles.vpc)
  project  = var.shared_vpc_host_project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.boa_terraform_deployment_sa.email}"
}

resource "google_project_iam_member" "boa_terraform_deployment_sa_roles_cicd" {
  for_each = toset(local.tf_deploy_sa_roles.cicd)
  project  = var.app_cicd_project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.boa_terraform_deployment_sa.email}"
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
  member     = "serviceAccount:${google_service_account.boa_terraform_deployment_sa.email}"
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
