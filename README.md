# Deploy Bank of Anthos on example-foundations

## Overview

This module contains additional Terraform configurations that are meant to fit into and modify the framework defined by [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation). 
These additional configurations can be used to securely deploy the Bank of Anthos example application.
**This is not a complete configuration - this configuration is expected to be used in conjunction with [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation/)**
After steps `0-bootstrap`, `1-org` and `2-environments` from [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation/) are configured completely, this module can be used to supplement the remaining steps. Each folder contains its own directory that must be applied separately, and in the following order, to correctly deploy the application:

## Instructions

1. Enable optional firewall rules in your shared VPC by modifying your 3-networks/envs/dev/main.tf and adding the following `optional_fw_rules_enabled = true`
1. Ensure that you have enabled the following APIs in your project, by adding `activate_apis = ["container.googleapis.com", "iap.googleapis.com"]`
1. Ensure that the user running terraform has the necessary permissions, including `roles/billing.user, roles/resourcemanager.organizationAdmin, roles/resourcemanager.projectCreator, roles/resourcemanager.folderAdmin, roles/iam.serviceAccountTokenCreator, roles/orgpolicy.policyAdmin, roles/logging.admin, roles/accesscontextmanager.policyAdmin, roles/securitycenter.admin, roles/compute.xpnAdmin, roles/compute.orgSecurityPolicyAdmin, and roles/compute.orgSecurityResourceAdmin` at the **org level** and `roles/owner` at the **project level**.
1. Set necessary variables as env vars or use a tfvars file. These will be outputs (TODO:example-foundation) after spinning up a project.
1. Perform the following commands on the root folder: `terraform init` to get the plugins, `terraform plan` to see the infrastructure plan and `terraform apply` to apply the infrastructure build
1. Run the command `gcloud compute ssh ... ` given by the output `bastion_ssh` in terminal window. This will open an ssh tunnel.
1. In a seperate terminal window run `gcloud container clusters ... ` given by the output `connect_svpc_cluster_internal`. This will generate the kubeconfig.
1. Run command `HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces` given by the output `example_kubectl_command` to verify the setup. This should list all pods across all ns.
1. Run `./deploy.sh` to deploy HipsterShop.
1. Run `HTTPS_PROXY=localhost:8888 kubectl get svc frontend-external` and wait till an external ip address has been assigned.

### [3. networks-extension](./app-foundation/3-networks/)

This step - a network *extension* - adds on top of the 3-networks layer that is part of [terraform-example-foundation/3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks). 
This step focuses on creating a shared VPC per environment (`development`, `non-production` & `production`) that is configured with subnets, secondary ranges, additional firewall rules, and a [network_prepare.sh](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/blob/main/app-foundation/3-networks-extension/network_prepare.sh) script included in the configuration that can be used to automatically populate or replace configurations in [terraform-example-foundation/3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks) with the configurations in the Bank of Anthos example.
Currently, this configuration includes:

- **Example subnets** for the `development`, `non-production` & `production` environments
- **Secondary ranges** for the application in all environments.
- **VPC firewall rules** for the application in all environments.
- **A Script** to automatically prepare the 3-networks layer in [terraform-example-foundation/3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks)

### [4. projects](./app-foundation/4-projects)

This step focuses on creating service projects, including an application CI/CD pipeline project and an infrastructure pipeline project that are necessary for the Bank of Anthos configuration to work. Currently, this includes:

- **5 Service projects** that are attached to the shared VPC
- **An Application CI/CD pipeline project** that will help with deployment of the example application
- **An Infrastructure pipeline project** that will also help with deployment of the example application

Once all steps above have been executed your GCP organization should represent the structure shown below, with projects being the lowest nodes in the tree.

```
example-organization/
└── fldr-bootstrap
    ├── prj-cloudbuild
    └── prj-seed
└── fldr-common
    ├── prj-bu1-s-app-cicd
    ├── prj-bu1-s-infra-pipeline
    ├── prj-c-billing-logs
    ├── prj-c-dns-hub
    ├── prj-c-interconnect
    ├── prj-c-logging
    ├── prj-c-scc
    └── prj-c-secrets
└── fldr-development
    ├── prj-bu1-d-boa-anthoshub
    ├── prj-bu1-d-boa-gke
    ├── prj-bu1-d-boa-ops
    ├── prj-bu1-d-boa-sec
    ├── prj-bu1-d-boa-sql
    ├── prj-d-monitoring
    ├── prj-d-secrets
    ├── prj-d-shared-base
    └── prj-d-shared-restricted
└── fldr-non-production
    ├── prj-bu1-n-boa-anthoshub
    ├── prj-bu1-n-boa-gke
    ├── prj-bu1-n-boa-ops
    ├── prj-bu1-n-boa-sec
    ├── prj-bu1-n-boa-sql
    ├── prj-n-monitoring
    ├── prj-n-secrets
    ├── prj-n-shared-base
    └── prj-n-shared-restricted
└── fldr-production
    ├── prj-bu1-p-boa-anthoshub
    ├── prj-bu1-p-boa-gke
    ├── prj-bu1-p-boa-ops
    ├── prj-bu1-p-boa-sec
    ├── prj-bu1-p-boa-sql
    ├── prj-p-monitoring
    ├── prj-p-secrets
    ├── prj-p-shared-base
    └── prj-p-shared-restricted
```

### [5. infrastructure](./5-infrastructure)

The purpose of this step is to deploy the infrastructure for the Bank of Anthos example application using the infra pipeline setup in 4-projects. There is also a [Source Repository](https://cloud.google.com/source-repositories) to push the code to be deployed. All infrastructure components will be created using the base network created during step [3-networks-extension](./app-foundation/3-networks/). Curretnly, this includes:

- **3 GKE Clusters**
  - Cluster1 in the primary region (us-east1)
  - Cluster2 in the secondary region (us-west1)
  - MCI Cluster in the primary region (us-east1)
- **A Bastion Host VM** in the secondary region (us-west1)
- **2 Postgres CLoudSQL instances** in the primary and secondary regions, respectively
- **A Secret** to store the CloudSQL Admin Password
- **4 KMS Keyrings and Keys**
  - 2 KMS Keyrings and Keys for GKE, one in each region
  - 2 KMS Keyrings and Keys for CloudSQL, one in each region
- **A Service Account for KMS** to own/manage the Keyrings and Keys
- **A Service Account for the Bastion Host VM** with roles to install Anthos Service Mesh
- **4 Log Sinks**, one in each project
- **Log Sink Destination Storage Bucket** that Log Sinks write logs to

### [6. anthos-install](./6-anthos-install)

The purpose of this step is to install the Anthos components required for the Bank of Anthos example application - Anthos Config Management and Anthos Service Mesh. **This step in the process is currently manual.**  Anthos Config Management can help you create a common configuration across all your infrastructure, including custom policies, and apply it both on-premises and across clouds. Anthos Service Mesh lets you easily manage the security and telemetry of complex environments.  Currently, this includes:

- All required components to install **Anthos Config Management**
- All required components to install **Anthos Service Mesh**

### [7. build_app](./build_app)

The purpose of this step is to utilize an opinionated repository to demonstrate Cloud Build based builds of Bank of Anthos with secure CI/CD principles applied. The example herein simulates a company building and deploying the Bank of Anthos example application to a multi-tier kubernetes cluster using asynchronous GitOps. Currently, this includes:

1. **Source Code** 
   - Unit tests are run for all source code
   - Static code analysis is performed on all source code
   - Secrets scanner looks for secrets embedded in source code
   - Code coverage numbers are pulled to make a decision based on the results

1. **Artifact Verification**
   - Container structure tests to verify that the container built in the previous step conforms to organizational standards
   - Container analysis to verify that the container does not contain Common Vulnerabilities and Exposures

1. **Security Attestation**
   - Creates an an attestation for the artifact  

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
