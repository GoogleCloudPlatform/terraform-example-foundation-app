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
  created_csrs     = toset([for repo in google_sourcerepo_repository.app_infra_repo : repo.name])
  artifact_buckets = { for created_csr in local.created_csrs : "${created_csr}-ab" => format("%s-%s-%s", created_csr, "cloudbuild-artifacts", random_id.suffix.hex) }
  gar_name         = split("/", google_artifact_registry_repository.tf-image-repo.name)[length(split("/", google_artifact_registry_repository.tf-image-repo.name)) - 1]
}

resource "google_sourcerepo_repository" "app_infra_repo" {
  for_each = toset(var.app_cicd_repos)
  project  = var.app_cicd_project_id
  name     = each.key
}

data "google_project" "app_cicd_project" {
  project_id = var.app_cicd_project_id
}

# Buckets for state and artifacts
resource "random_id" "suffix" {
  byte_length = 2
}

resource "google_storage_bucket" "cloudbuild_artifacts" {
  for_each                    = local.artifact_buckets
  project                     = var.app_cicd_project_id
  name                        = each.value
  location                    = var.primary_location
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "cloudbuild_artifacts_iam" {
  for_each   = local.artifact_buckets
  bucket     = each.value
  role       = "roles/storage.admin"
  member     = "serviceAccount:${data.google_project.app_cicd_project.number}@cloudbuild.gserviceaccount.com"
  depends_on = [google_storage_bucket.cloudbuild_artifacts]
}

# Cloud Build plan/apply triggers
resource "google_cloudbuild_trigger" "main_trigger" {
  for_each    = local.created_csrs
  project     = var.app_cicd_project_id
  description = "${each.value}- trigger."
  trigger_template {
    branch_name = ".*"
    repo_name   = each.value
  }
  substitutions = {
    _GAR_REPOSITORY       = local.gar_name
    _ARTIFACT_BUCKET_NAME = google_storage_bucket.cloudbuild_artifacts["${each.value}-ab"].name
  }
  filename = "cloudbuild.yaml"
  depends_on = [google_sourcerepo_repository.app_infra_repo]
}

/***********************************************
 Cloud Build - Terraform Image Repo
 ***********************************************/
resource "google_artifact_registry_repository" "tf-image-repo" {
  provider      = google-beta
  project       = var.app_cicd_project_id
  location      = var.primary_location
  repository_id = format("%s-%s", var.app_cicd_project_id, "tf-runners")
  description   = "Docker repository for Terraform runner images used by Cloud Build"
  format        = "DOCKER"
}

/***********************************************
 Cloud Build - Terraform builder
 ***********************************************/

resource "null_resource" "cloudbuild_terraform_builder" {
  triggers = {
    project_id_cloudbuild_project = var.app_cicd_project_id
    terraform_version_sha256sum   = var.terraform_version_sha256sum
    terraform_version             = var.terraform_version
    gar_name                      = local.gar_name
    gar_location                  = google_artifact_registry_repository.tf-image-repo.location
  }

  provisioner "local-exec" {
    command = <<EOT
      gcloud builds submit ${path.module}/cloudbuild_builder/ \
      --project ${var.app_cicd_project_id} \
      --config=${path.module}/cloudbuild_builder/cloudbuild.yaml \
      --substitutions=_TERRAFORM_VERSION=${var.terraform_version},_TERRAFORM_VERSION_SHA256SUM=${var.terraform_version_sha256sum},_TERRAFORM_VALIDATOR_RELEASE=${var.terraform_validator_release},_REGION=${google_artifact_registry_repository.tf-image-repo.location},_REPOSITORY=${local.gar_name}
  EOT
  }
  depends_on = [
    google_artifact_registry_repository_iam_member.terraform-image-iam
  ]
}

resource "google_artifact_registry_repository_iam_member" "terraform-image-iam" {
  provider   = google-beta
  project    = var.app_cicd_project_id
  location   = google_artifact_registry_repository.tf-image-repo.location
  repository = google_artifact_registry_repository.tf-image-repo.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${data.google_project.app_cicd_project.number}@cloudbuild.gserviceaccount.com"
}
