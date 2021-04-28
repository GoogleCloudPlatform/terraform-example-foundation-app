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
  cicd_tf_deploy_sa_roles = [
    "roles/viewer",
    "roles/storage.admin",
    "roles/cloudkms.admin",
    "roles/binaryauthorization.attestorsEditor",
    "roles/cloudkms.signerVerifier",
    "roles/containeranalysis.occurrences.editor",
    "roles/containeranalysis.notes.occurrences.viewer",
    "roles/containeranalysis.notes.attacher",
    "roles/container.developer",
    "roles/secretmanager.secretAccessor",
    "roles/containeranalysis.notes.editor",
    "roles/artifactregistry.admin",
    "roles/secretmanager.admin",
    "roles/source.admin",
    "roles/cloudbuild.builds.editor"
  ]
}

module "app_cicd_project" {
  source                      = "github.com/terraform-google-modules/terraform-example-foundation/4-projects/modules/single_project"
  impersonate_service_account = var.terraform_service_account
  org_id                      = var.org_id
  billing_account             = var.billing_account
  folder_id                   = data.google_active_folder.common.name
  environment                 = "common"
  alert_spent_percents        = var.alert_spent_percents
  alert_pubsub_topic          = var.alert_pubsub_topic
  budget_amount               = var.budget_amount
  project_prefix              = var.project_prefix
  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudbuild.googleapis.com",
    "sourcerepo.googleapis.com",
    "artifactregistry.googleapis.com",
    "containeranalysis.googleapis.com",
    "containerscanning.googleapis.com",
    "binaryauthorization.googleapis.com",
    "secretmanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "cloudkms.googleapis.com",
    "anthos.googleapis.com",
    "serviceusage.googleapis.com"
  ]

  # Metadata
  project_suffix    = "app-cicd"
  application_name  = "boa-app-pipeline"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "bu1"
}

resource "google_service_account" "app_cicd_build_sa" {
  account_id  = "cicd-build-sa"
  description = "Service account to allow terraform to deploy shared resources in app_cicd project"
  project     = module.app_cicd_project.project_id
}

resource "google_project_iam_member" "app_cicd_build_sa_roles" {
  for_each = toset(local.cicd_tf_deploy_sa_roles)
  project  = module.app_cicd_project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.app_cicd_build_sa.email}"
}

resource "google_service_account_iam_member" "app_cicd_build_sa_impersonate_permissions" {
  service_account_id = google_service_account.app_cicd_build_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${module.app_infra_cloudbuild_project.project_number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "app_cicd_cloudbuild_sa_roles" {
  project = module.app_cicd_project.project_id
  role    = "roles/source.admin"
  member  = "serviceAccount:${module.app_cicd_project.project_number}@cloudbuild.gserviceaccount.com"
}
