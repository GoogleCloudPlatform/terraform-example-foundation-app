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

org_id                           = "xxxxxx-xxxxxx-xxxxxx"
billing_account                  = "xxxxxxxxxxxx"
terraform_service_account        = "org-terraform@prj-seed-xxxx.iam.gserviceaccount.com"
app_infra_pipeline_cloudbuild_sa = "xxxxxxxxxxxx@cloudbuild.gserviceaccount.com"
app_cicd_project_id              = "prj-bu1-s-app-cicd-xxxx"
shared_vpc_host_project_id       = "prj-d-shared-base-xxxx"
shared_vpc_network_name          = "vpc-d-shared-base-spoke"
enable_hub_and_spoke             = true

# Optional
# parent_folder = ""
