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
  gar_name         = split("/", google_artifact_registry_repository.image_repo.name)[length(split("/", google_artifact_registry_repository.image_repo.name)) - 1]
  folders          = ["cache/.m2/.ignore", "cache/.skaffold/.ignore", "cache/.cache/pip/wheels/.ignore"]
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

resource "google_cloudbuild_trigger" "boa_build_trigger" {
  project     = var.app_cicd_project_id
  description = "bank-of-anthos-source-trigger."
  trigger_template {
    branch_name = ".*"
    repo_name   = "bank-of-anthos-source"
  }
  substitutions = {
    _GAR_REPOSITORY    = local.gar_name
    _DEFAULT_REGION    = var.primary_location
    _CACHE_BUCKET_NAME = "${var.app_cicd_project_id}_cloudbuild"
  }
  filename   = var.cloudbuild_yaml
  depends_on = [google_sourcerepo_repository.app_infra_repo]
}

resource "null_resource" "cloudbuild_image_builder" {
  triggers = {
    project_id_cloudbuild_project = var.app_cicd_project_id
  }

  provisioner "local-exec" {
    command = <<EOT
      gcloud builds submit ${path.module}/cloud-build-builder/ \
      --project ${var.app_cicd_project_id} \
      --config=${path.module}/cloud-build-builder/cloudbuild-skaffold-build-image.yaml \
      --substitutions=_DEFAULT_REGION=${var.primary_location},_GAR_REPOSITORY=${local.gar_name}
  EOT
  }
}

/***********************************************
 Cloud Build - Image Repo
 ***********************************************/

resource "google_artifact_registry_repository" "image_repo" {
  provider      = google-beta
  project       = var.app_cicd_project_id
  location      = var.primary_location
  repository_id = format("%s-%s", var.app_cicd_project_id, "boa-image-repo")
  description   = "Docker repository for Bank Of Anthos images"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "terraform-image-iam" {
  provider   = google-beta
  project    = var.app_cicd_project_id
  location   = google_artifact_registry_repository.image_repo.location
  repository = google_artifact_registry_repository.image_repo.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${data.google_project.app_cicd_project.number}@cloudbuild.gserviceaccount.com"
}

/***********************************************
 Cache Storage Bucket
 ***********************************************/

resource "google_storage_bucket" "cache_bucket" {
  project                     = var.app_cicd_project_id
  name                        = "${var.app_cicd_project_id}_cloudbuild"
  location                    = var.primary_location
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_object" "cache_bucket_folders" {
  for_each = toset(local.folders)
  name     = each.value
  content  = "/n"
  bucket   = google_storage_bucket.cache_bucket.name
}
