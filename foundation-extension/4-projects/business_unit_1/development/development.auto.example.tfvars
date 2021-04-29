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

org_id                           = "000000000000"
billing_account                  = "000000-000000-000000"
terraform_service_account        = "org-terraform@prj-b-seed-2334.iam.gserviceaccount.com"
app_infra_pipeline_cloudbuild_sa = "<bu1_infra_pipeline_project_number>@cloudbuild.gserviceaccount.com"
enable_hub_and_spoke             = true
app_cicd_project_id              = "prj-bu1-c-app-cicd-1234"
shared_vpc_host_project_id       = "prj-d-shared-base-1234"
shared_vpc_network_name          = "vpc-d-shared-base-spoke"

// Optional - for an organization with existing projects or for development/validation.
// Must be the same value used in previous steps.
//parent_folder = "01234567890"
