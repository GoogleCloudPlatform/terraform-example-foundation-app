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

output "app_cicd_project_id" {
  value = module.app_cicd_project.project_id
}

output "app_cicd_build_sa" {
  value = google_service_account.app_cicd_build_sa.email
}

output "app_infra_cloudbuild_project_id" {
  value = module.app_infra_cloudbuild_project.project_id
}

output "app_infra_repos" {
  description = "CSRs to store source code"
  value       = module.infra_pipelines.repos
}

output "app_infra_pipeline_cloudbuild_sa" {
  value = "${module.app_infra_cloudbuild_project.project_number}@cloudbuild.gserviceaccount.com"
}
