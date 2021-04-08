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
  Outputs for BoA subnets
*****************************************/

output "boa_subnets" {
  value       = var.subnets
  description = "The created VPC subnets."
}

/******************************************
 Outputs for private services address
*****************************************/

output "private_services_address" {
  value       = google_compute_global_address.private_services_address.address
  description = "The external IP for Cloud SQL."
}

/******************************************
  Outputs for external IP
*****************************************/

output "external_ip_address" {
  value       = google_compute_global_address.external_ip_for_http_load_balancing.address
  description = "The external IP for Cloud SQL."
}
