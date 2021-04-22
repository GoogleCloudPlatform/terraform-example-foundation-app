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

module "cicd_pipeline" {
  source                = "../../modules/app_cicd_pipeline"
  app_cicd_build_sa     = var.app_cicd_build_sa
  app_cicd_project_id   = var.app_cicd_project_id
  app_cicd_repos        = ["bank-of-anthos-source", "root-config-repo", "accounts", "transactions", "frontend"]
  boa_build_repo        = "bank-of-anthos-source"
  gar_repo_name_suffix  = "boa-image-repo"
  primary_location      = var.primary_location
  attestor_names_prefix = ["build", "quality", "security"]
  build_app_yaml        = "cloudbuild-build-boa.yaml"
  build_image_yaml      = "cloudbuild-skaffold-build-image.yaml"
}
