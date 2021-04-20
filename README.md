# Deploy Bank of Anthos on example-foundations

## Order of Execution

<table>
<tbody>
<tr>
<td><a
href="https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/0-bootstrap">0-bootstrap</a></td>
<td>Bootstraps a Google Cloud organization, creating all the required resources
and permissions to start using the Cloud Foundation Toolkit (CFT). This
step also configures a CI/CD pipeline for foundations code in subsequent
stages.</td>
</tr>
<tr>
<td><a
href="https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/1-org">1-org</a></td>
<td>Sets up top level shared folders, monitoring and networking projects, and
organization-level logging, and sets baseline security settings through
organizational policy.</td>
</tr>
<tr>
<td><a
href="https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/2-environments">2-environments</a></td>
<td>Sets up development, non-production, and production environments within the
Google Cloud organization that you've created.</td>
</tr>
<tr>
<td><a
href="https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/app-foundation/3-networks-extension">3-networks-extension/</a></td>
<td>Sets up base shared VPCs with .</td>
</tr>
<tr>
<td><a
href="https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks">3-networks</a></td>
<td>Sets up base and restricted shared VPCs with default DNS, NAT (optional),
Private Service networking, VPC service controls, on-premises Dedicated
Interconnect, and baseline firewall rules for each environment. Also sets
up the global DNS hub.</td>
</tr>
<tr>
<td><a
href="https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/app-foundation/4-projects">4-projects</a></td>
<td>Set up a folder structure, projects, and application infrastructure pipeline for applications,
 which are connected as service projects to the shared VPC created in the previous stage.</td>
</tr>
<tr>
<td><a
href="https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/5-infrastructure">5-infrastructure</a></td>
<td>Set up resources needed to deploy bank of anthos, GKE Clusters, CloudSQL Instances, Logging Buckets, Bastion Host, KMS, Artifact Repository, Binary Auth etc.</td>
</tr>
<tr>
<td><a
href="https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/6-anthos-install">6-anthos</a></td>
<td>Set up ACM, ASM and other pre-requistes for Bank of Anthos Application.</td>
</tr>
<tr>
<td><a
href="https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/build-app">BoA Build</a></td>
<td>Set up Bank of Anthos Application.</td>
</tr>
</tbody>
</table>

## Instructions

1. Enable optional firewall rules in your shared VPC by modifying your 3-networks/envs/dev/main.tf and adding the following `optional_fw_rules_enabled = true`
1. Ensure that you have enabled the following APIs enabled in your project, by adding `activate_apis = ["container.googleapis.com", "iap.googleapis.com"]`
1. Ensure that the user running the terraform has necessary permissions (TODO: add required permissions here).
1. Set necessary variables as env vars or tfvars file. These will be outputs (TODO:example-foundation) after spinning up a project.
1. tf init, plan and apply
1. Run the command `gcloud compute ssh ... ` given by the output `bastion_ssh` in terminal window. This will open an ssh tunnel.
1. In a seperate terminal window run `gcloud container clusters ... ` given by the output `connect_svpc_cluster_internal`. This will generate the kubeconfig.
1. Run command `HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces` given by the output `example_kubectl_command` to verify the setup. This should list all pods across all ns.
1. Run `./deploy.sh` to deploy HipsterShop.
1. Run `HTTPS_PROXY=localhost:8888 kubectl get svc frontend-external` and wait till an external ip address has been assigned.
## Source Code Headers

Every file containing source code must include copyright and license
information. This includes any JS/CSS files that you might be serving out to
browsers. (This is to help well-intentioned people avoid accidental copying that
doesn't comply with the license.)

Apache header:

    Copyright 2021 Google LLC

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
