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

output "boa_gke_project_id" {
  description = "Project ID for GKE Project"
  value       = module.boa_gke_project.project_id
}

output "boa_ops_project_id" {
  description = "Project ID for Ops Project"
  value       = module.boa_ops_project.project_id
}

output "boa_sec_project_id" {
  description = "Project ID for Secrets Project"
  value       = module.boa_secret_project.project_id
}

output "boa_sql_project_id" {
  description = "Project ID for SQL Project"
  value       = module.boa_sql_project.project_id
}

output "terraform_service_account" {
  description = "Terraform Deployment SA for 5-infrastructure"
  value       = google_service_account.boa_terraform_deployment_sa.email
}

output "boa_gsa_sa_email" {
  description = "SA email for boa-gsa service account"
  value       = google_service_account.boa_gsa_sa.email
}
