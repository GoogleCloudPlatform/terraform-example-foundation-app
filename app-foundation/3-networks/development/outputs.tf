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
  Development Network Outputs
*****************************************/

output "base_host_project_id" {
  value       = local.base_project_id
  description = "The base host project ID"
}

output "base_network_name" {
  value       = module.base_shared_vpc.network_name
  description = "The name of the VPC being created"
}

output "base_network_self_link" {
  value       = module.base_shared_vpc.network_self_link
  description = "The URI of the VPC being created"
}

output "base_subnets" {
  value       = var.subnets
  description = "The VPC subnets."
}
