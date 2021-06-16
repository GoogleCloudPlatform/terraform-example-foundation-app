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

# xxxx in the following variables is replaced by random project suffix
boa_gke_project_id        = "prj-bu1-n-boa-gke-xxxx"
boa_ops_project_id        = "prj-bu1-n-boa-ops-xxxx"
boa_sec_project_id        = "prj-bu1-n-boa-sec-xxxx"
boa_sql_project_id        = "prj-bu1-n-boa-sql-xxxx"
gcp_shared_vpc_project_id = "prj-n-shared-base-xxxx"
shared_vpc_name           = "vpc-n-shared-base-spoke"
terraform_service_account = "boa-terraform-n-sa@prj-bu1-n-boa-sec-xxxx.iam.gserviceaccount.com"

enforce_bin_auth_policy      = false
bin_auth_attestor_names      = ["build-attestor", "quality-attestor", "security-attestor"]
bin_auth_attestor_project_id = "prj-bu1-c-app-cicd-xxxx"

# Replace 'example@example.com' with your GCP Cloud Identity
# to be added as an allowlisted member on the bastion host.
# You need access to the bastion host to execute
# step 6-anthos-install.
bastion_members = ["user:example@example.com"]

# Use the same configuration used by the Bank of Anthos applications to connect to the database.
# See:
# - terraform-example-foundation-app/6-anthos-install/acm-repos/root-config-repo/namespaces/boa/accounts/accounts-db-config.yaml
# - terraform-example-foundation-app/6-anthos-install/acm-repos/root-config-repo/namespaces/boa/transactions/ledger-db-config.yaml
sql_admin_username = "admin"
sql_admin_password = "admin"
