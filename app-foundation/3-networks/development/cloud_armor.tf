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
  base_project_id = data.google_projects.base_host_project.projects[0].project_id
}

/******************************************
 Cloud Armor policy
*****************************************/

resource "google_compute_security_policy" "cloud-armor-xss-policy" {
  name    = var.policy_name
  project = local.base_project_id
  rule {
    action   = var.policy_action
    priority = var.policy_priority
    match {
      expr {
        expression = var.policy_expression
      }
    }
    description = var.policy_description
  }

}
