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
  sa_permissions = [
    "roles/viewer",
    "roles/storage.admin",
    "roles/cloudkms.admin",
    "roles/binaryauthorization.attestorsViewer",
    "roles/cloudkms.signerVerifier",
    "roles/containeranalysis.occurrences.editor",
    "roles/containeranalysis.notes.occurrences.viewer",
    "roles/containeranalysis.notes.attacher",
    "roles/container.developer",
    "roles/secretmanager.secretAccessor",
    "roles/containeranalysis.notes.editor",
    "roles/artifactregistry.admin"
  ]
  sa_roles = [for role in local.sa_permissions : "${module.app_cicd_project.project_id}=>${role}"]
}

module "app_cicd_project" {
  source                      = "github.com/terraform-google-modules/terraform-example-foundation/4-projects/modules/single_project"
  impersonate_service_account = var.terraform_service_account
  org_id                      = var.org_id
  billing_account             = var.billing_account
  folder_id                   = data.google_active_folder.common.name
  environment                 = "shared"
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

module "app_cicd_build_sa" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = module.app_cicd_project.project_id
  names         = ["cicd-build-sa"]
  project_roles = local.sa_roles
}

resource "google_secret_manager_secret" "cicd_build_gsa_key_secret" {
  project   = module.app_cicd_project.project_id
  secret_id = "cicd_build_sa_key"
  labels = {
    label = "cicd-build-sa-key"
  }
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "cicd-build-gsa-key-secret-version" {
  secret      = google_secret_manager_secret.cicd_build_gsa_key_secret.id
  secret_data = "key_file" # Should be 'module.app_cicd_build_sa.key' if allowed by org-policy
}
