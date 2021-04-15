# terraform-example-foundation-app/app-foundation

## Overview
The `app-foundation` folder contains several distinct Terraform configurations that can supplement the CFT to deploy the necessary foundation for the Bank of Anthos example application. These configurations are meant to fit into the framework defined by [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation). Each folder contains its own directory that must be applied separately, and in sequence, to correctly deploy the application. The necessary steps are outlined below for the relevant folders.

### [3. networks](./3-networks/)

This step focuses on creating a Shared VPC per environment (`development`, `non-production` & `production`) that is consistent with the Bank of Anthos application's configuration and has a reasonable security baseline. **This is not a complete configuration - this configuration is expected to be used in conjunction with [terraform-example-foundation/3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks) in hub and spoke mode**. Currently, this supplemental configuration includes:

- Example subnets for `development`, `non-production` & `production` inclusive of secondary ranges for the Bank of Anthos application.
- Additional firewall rules that are necessary for the configuration to work. **Please note that there are temporary firewall rules within this configuration that should be removed once the entire Bank of Anthos deployment is complete.**

Usage instructions are available for the networks step in the [README](./3-networks/README.md).

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
