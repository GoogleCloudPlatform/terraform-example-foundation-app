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

module "boa_anthoshub_project" {
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
    "gkehub.googleapis.com",
    "anthos.googleapis.com",
    "containerscanning.googleapis.com",
    "multiclusteringress.googleapis.com"
  ]

  # Metadata
  project_suffix    = "boa-anthoshub"
  application_name  = "bu1-sample-application"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "bu1"
}


# SA for Anthos Project to act upon GKE and SQL ressources in respective projects
module "boa_gsa_sa" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 3.0"
  project_id = module.boa_anthoshub_project.project_id
  names      = ["boa-gsa"]
  project_roles = [
    "${module.boa_gke_project.project_id}=>roles/cloudtrace.agent",
    "${module.boa_gke_project.project_id}=>roles/monitoring.metricWriter",
    "${module.boa_gke_project.project_id}=>roles/iam.serviceAccountUser",
    "${module.boa_sql_project.project_id}=>roles/cloudsql.client"
  ]
}
