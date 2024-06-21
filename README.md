# Deploy Bank of Anthos on example-foundations

> [!WARNING]  
> This blueprint is now deprecated. Please refer to the [enterprise application blueprint](https://github.com/GoogleCloudPlatform/terraform-google-enterprise-application) for an updated implementation of GKE as an internal developer platform.

## Overview

This module contains additional Terraform configurations that are meant to extend and modify the framework defined by [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation).
These additional configurations can be used to securely deploy the Bank of Anthos example application.
**This is not a complete configuration - this configuration is expected to be used in conjunction with [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation/).**
Within this supplemental configuration, hub-and-spoke mode is enabled be default. If you wish to use this configuration without modifications, please ensure that hub-and-spoke mode was enabled on step `1-org` from [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation/) or go back and enable it so the necessary hub-and-spoke infrastructure is built.
After steps `0-bootstrap`, `1-org` and `2-environments` from [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation/) are configured completely, this module can be used to supplement the remaining steps. Each folder contains its own directory that must be applied separately, and in the following order, to correctly deploy the application:

## Order of Execution

<table>
<tbody>
<tr>
<td nowrap="nowrap"><a
href="https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/0-bootstrap">0-bootstrap</a></td>
<td>Bootstraps a Google Cloud organization, creating all the required resources
and permissions to start using the Cloud Foundation Toolkit (CFT). This
step also configures a CI/CD pipeline for foundations code in subsequent
stages.</td>
</tr>
<tr>
<td nowrap="nowrap"><a
href="https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/1-org">1-org</a></td>
<td>Sets up top level shared folders, monitoring and networking projects, and
organization-level logging, and sets baseline security settings through
organizational policy.</td>
</tr>
<tr>
<td nowrap="nowrap"><a
href="https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/2-environments">2-environments</a></td>
<td>Sets up development, non-production, and production environments within the
Google Cloud organization that you've created.</td>
</tr>
<tr>
<td nowrap="nowrap"><a
href="https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/foundation-extension/3-networks-extension">3-networks-extension</a></td>
<td>Sets up base shared VPCs with BOA Subnets and Firewall Rules, need only run the bash script to complete this step.</td>
</tr>
<tr>
<td nowrap="nowrap"><a
href="https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks">3-networks</a></td>
<td>Sets up base and restricted shared VPCs with default DNS, NAT (optional), Private Service networking, VPC service controls, on-premises Dedicated Interconnect, and baseline firewall rules for each environment. Also sets up the global DNS hub.</td>
</tr>
<tr>
<td nowrap="nowrap"><a
href="https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/foundation-extension/4-projects">4-projects</a></td>
<td>Set up a folder structure, projects, and application infrastructure pipeline for applications,
 which are connected as service projects to the shared VPC created in the previous stage.</td>
</tr>
<tr>
<td nowrap="nowrap"><a
href="https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/5-infrastructure">5-infrastructure</a></td>
<td>Set up resources needed to deploy bank of anthos, GKE Clusters, CloudSQL Instances, Logging Buckets, Bastion Host, KMS, Artifact Repository, Binary Auth etc.</td>
</tr>
<tr>
<td nowrap="nowrap"><a
href="https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/6-anthos-install">6-anthos</a></td>
<td>Set up ACM, ASM and other pre-requistes for Bank of Anthos Application.</td>
</tr>
<tr>
<td nowrap="nowrap"><a
href="https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/7-app-build-deploy">7-app-build-deploy</a></td>
<td>Set up Bank of Anthos Application.</td>
</tr>
</tbody>
</table>

## [3. networks-extension](./foundation-extension/3-networks-extension/)

This step - a network *extension* - adds on top of the 3-networks layer that is part of [terraform-example-foundation/3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks).
This step focuses on creating a shared VPC per environment (`development`, `non-production` & `production`) that is configured with subnets, secondary ranges, additional firewall rules, and a [network_prepare.sh](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/blob/main/foundation-extension/3-networks-extension/network_prepare.sh) script included in the configuration that can be used to automatically populate or replace configurations in [terraform-example-foundation/3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks) with the configurations in the Bank of Anthos example.
Currently, this configuration includes:

- **Example subnets** for the `development`, `non-production` & `production` environments
- **Secondary ranges** for the subnets in all environments.
- **VPC firewall rules** for the VPC network in all environments.

**A Bash Script** to automatically prepare the 3-networks layer by auto-merging 3-networks-extension with the 3-networks from [terraform-example-foundation/3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks)

## [4. projects](./foundation-extension/4-projects)

This step focuses on creating service projects, including an application CI/CD pipeline project and an infrastructure pipeline project that are necessary for the Bank of Anthos configuration to work. Currently, this includes:

- **5 Service projects** that are attached to the shared VPC for each environment
- **An Application CI/CD pipeline project** that will help with deployment of the example application
- **An Infrastructure pipeline project** that will also help with deployment of the example application

Once all steps above have been executed your GCP organization should represent the structure shown below, with projects being the lowest nodes in the tree.

```
example-organization/
└── fldr-bootstrap
    ├── prj-cloudbuild
    └── prj-seed
└── fldr-common
    ├── prj-bu1-c-app-cicd
    ├── prj-bu1-c-infra-pipeline
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

## [5. infrastructure](./5-infrastructure)

The purpose of this step is to deploy the infrastructure for the Bank of Anthos example application using the infra pipeline setup in 4-projects. There is also a [Source Repository](https://cloud.google.com/source-repositories) to push the code to be deployed. All infrastructure components will be created using the base network created during step [3-networks-extension](./foundation-extension/3-networks/). Curretnly, this includes:

- **3 GKE Clusters**
  - Cluster1 in the primary region (us-east1)
  - Cluster2 in the secondary region (us-west1)
  - MCI Cluster in the primary region (us-east1)
- **Bastion Host VM** in the secondary region (us-west1)
- **2 Postgres CLoudSQL instances** in the primary and secondary regions, respectively
- **Secret** to store the CloudSQL Admin Password
- **4 KMS Keyrings and Keys**
  - 2 KMS Keyrings and Keys for GKE, one in each region
  - 2 KMS Keyrings and Keys for CloudSQL, one in each region
- **Service Account for KMS** to own/manage the Keyrings and Keys
- **Service Account for the Bastion Host VM** with roles to install Anthos Service Mesh
- **4 Log Sinks**, one in each project
- **Log Sink Destination Storage Bucket** that Log Sinks write logs to
- **Cloud Armor Policy**
- **External IP** for accessing the application externally

## [6. anthos-install](./6-anthos-install)

The purpose of this step is to install the Anthos components required for the Bank of Anthos example application - Anthos Config Management and Anthos Service Mesh. **This step in the process is currently manual.**  Anthos Config Management can help you create a common configuration across all your infrastructure, including custom policies, and apply it both on-premises and across clouds. Anthos Service Mesh lets you easily manage the security and telemetry of complex environments.  Currently, this includes:

- All required components to install **Anthos Config Management**
- All required components to install **Anthos Service Mesh**

## [7. app-build-deploy](./7-app-build-deploy)

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

---
This is not an officially supported Google product
