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

/******************************************
  Auto Find Environment Projects
*****************************************/

locals {
  auto_gke_project_id        = length(data.google_projects.gke_project.projects) != 0 ? lookup(element(lookup(data.google_projects.gke_project, "projects", ""), 0), "project_id", "") : ""
  auto_ops_project_id        = length(data.google_projects.ops_project.projects) != 0 ? lookup(element(lookup(data.google_projects.ops_project, "projects", ""), 0), "project_id", "") : ""
  auto_sec_project_id        = length(data.google_projects.sec_project.projects) != 0 ? lookup(element(lookup(data.google_projects.sec_project, "projects", ""), 0), "project_id", "") : ""
  auto_sql_project_id        = length(data.google_projects.sql_project.projects) != 0 ? lookup(element(lookup(data.google_projects.sql_project, "projects", ""), 0), "project_id", "") : ""
  auto_shared_vpc_project_id = length(data.google_projects.shared_vpc_project.projects) != 0 ? lookup(element(lookup(data.google_projects.shared_vpc_project, "projects", ""), 0), "project_id", "") : ""
}

data "google_projects" "gke_project" {
  filter = "name:${var.project_prefix}-${var.business_unit}-${var.environment_code}-boa-gke"
}

data "google_projects" "ops_project" {
  filter = "name:${var.project_prefix}-${var.business_unit}-${var.environment_code}-boa-ops"
}

data "google_projects" "sec_project" {
  filter = "name:${var.project_prefix}-${var.business_unit}-${var.environment_code}-boa-sec"
}

data "google_projects" "sql_project" {
  filter = "name:${var.project_prefix}-${var.business_unit}-${var.environment_code}-boa-sql"
}

data "google_projects" "shared_vpc_project" {
  filter = "name:${var.project_prefix}-${var.environment_code}-shared-base"
}
