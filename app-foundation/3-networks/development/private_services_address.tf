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
 Private services address for Cloud SQL
*****************************************/

resource "google_compute_global_address" "private_services_address" {
  name          = var.private_services_address_name
  project       = local.base_project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = element(split("/", local.base_private_service_cidr), 0)
  prefix_length = element(split("/", local.base_private_service_cidr), 1)
  network       = module.base_shared_vpc.network_self_link
}
