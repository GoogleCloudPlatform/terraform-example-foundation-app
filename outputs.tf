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

output "connect_svpc_cluster_internal" {
  value       = "gcloud container clusters get-credentials ${local.cluster_name} --region ${var.region} --project ${var.project_id} --internal-ip"
  description = "Command to generate kubeconfig with internal ip"
}

output "bastion_ssh" {
  value       = "gcloud compute ssh ${local.bastion_name} --project ${var.project_id} --zone ${local.bastion_zone} --tunnel-through-iap -- -L8888:127.0.0.1:8888"
  description = "Command to SSH via IAP"
}


output "example_kubectl_command" {
  value       = "HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces "
  description = "Test command through bastion proxy"
}