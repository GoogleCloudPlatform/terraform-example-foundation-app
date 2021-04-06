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

output "hostname" {
  description = "Host name of the bastion"
  value       = module.iap_bastion.hostname
}

output "ip_address" {
  description = "Internal IP address of the bastion host"
  value       = module.iap_bastion.ip_address
}

output "self_link" {
  description = "Self link of the bastion host"
  value       = module.iap_bastion.self_link
}

output "service_account_email" {
  description = "Email address of the SA created for the bastion host"
  value       = module.iap_bastion.service_account
}

output "cidr_range" {
  description = "Internal IP address range of the bastion host"
  value       = data.google_compute_subnetwork.bastion_subnet.ip_cidr_range
}

output "subnet_name" {
  description = "Self link of the bastion host"
  value       = data.google_compute_subnetwork.bastion_subnet.name
}
