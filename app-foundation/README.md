# terraform-example-foundation-app/app-foundation

## Overview
The `app-foundation` folder contains additional Terraform configurations required for Bank Of Anthos deployment and are meant to fit into the framework defined by [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation). Each folder contains its own directory that must be applied separately, and in sequence, to correctly deploy the application. The necessary steps are outlined below for the relevant folders.

### [3. networks](./3-networks-extension/)

This step - a network *extension* - adds on top of the 3-networks layer that is part of [terraform-example-foundation/3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks).
This step focuses on creating a shared VPC per environment (`development`, `non-production` & `production`) that is configured with subnets, secondary ranges, additional firewall rules, and a [network_prepare.sh](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/blob/main/app-foundation/3-networks-extension/network_prepare.sh) script included in the configuration that can be used to automatically populate or replace configurations in [terraform-example-foundation/3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks) with the configurations in the Bank of Anthos example.
Currently, this configuration includes:

- **Example subnets** for the `development`, `non-production` & `production` environments
- **Secondary ranges** for the subnets in all environments.
- **VPC firewall rules** for the VPC network in all environments.

**A Bash Script** to automatically prepare the 3-networks layer by auto-merging 3-networks-extension with the 3-networks from [terraform-example-foundation/3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks)
Usage instructions are available for the networks step in the [README](./3-networks-extension/README.md).

### [4. projects](./4-projects/)

This step focuses on creating service projects, including an application CI/CD pipeline project and an infrastructure pipeline project that are necessary for the Bank of Anthos configuration to work. Currently, this includes:

- 5 service projects with a standard configuration that are attached to the shared VPC in the previous step
- An application CI/CD pipeline project that will help with deployment of the example application
- An infrastructure pipeline project that will also help with deployment of the example application

Deploying this code as-is will generate the additional folder structure shown below:

```
example-organization/
└── fldr-development
    ├── prj-bu1-d-boa-anthoshub
    ├── prj-bu1-d-boa-gke
    ├── prj-bu1-d-boa-ops
    ├── prj-bu1-d-boa-sec
    └── prj-bu1-d-boa-sql
└── fldr-non-production
    ├── prj-bu1-n-boa-anthoshub
    ├── prj-bu1-n-boa-gke
    ├── prj-bu1-n-boa-ops
    ├── prj-bu1-n-boa-sec
    └── prj-bu1-n-boa-sql
└── fldr-production
    ├── prj-bu1-p-boa-anthoshub
    ├── prj-bu1-p-boa-gke
    ├── prj-bu1-p-boa-ops
    ├── prj-bu1-p-boa-sec
    └── prj-bu1-p-boa-sql
└── fldr-common
    ├── prj-bu1-s-app-cicd
    └── prj-bu1-s-infra-pipeline
```
