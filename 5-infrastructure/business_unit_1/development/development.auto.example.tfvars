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

parent_folder             = "000000000000"
boa_gke_project_id        = "prj-bu1-z-boa-gke-xxxx" # 'z' is replaced by {d|n|p} according to environment {development|non-production|production}
boa_ops_project_id        = "prj-bu1-z-boa-ops-xxxx" # 'z' is replaced by {d|n|p} according to environment {development|non-production|production}
boa_sec_project_id        = "prj-bu1-z-boa-sec-xxxx" # 'z' is replaced by {d|n|p} according to environment {development|non-production|production}
boa_sql_project_id        = "prj-bu1-z-boa-sql-xxxx" # 'z' is replaced by {d|n|p} according to environment {development|non-production|production}
gcp_shared_vpc_project_id = "prj-z-shared-base-xxxx" # 'z' is replaced by {d|n|p} according to environment {development|non-production|production}
shared_vpc_name           = "vpc-yyy-shared-base-spoke"    # 'yyy' is replaced by {dev|npd|prd} according to environment {development|non-production|production}
terraform_service_account = "boa-terraform-z-sa@xxxxxxxxxx.iam.gserviceaccount.com"

# Optional
# gke_cluster_1_cidr_block   = "000.000.000.000/00"
# gke_cluster_2_cidr_block   = "000.000.000.000/00"
# gke_mci_cluster_cidr_block = "000.000.000.000/00"
