# 3-networks/development

This is an additional Terraform configuration for [CFT 3-Networks/envs/development](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks/envs/development) and can be used to set up the subnets, additional firewall rules, Cloud Armor, private service networking, and an external IP address for the Bank of Anthos example application in the development environment.

## Prerequisites

1. 0-bootstrap executed successfully.
1. 1-org executed successfully.
1. 2-environments/envs/development executed successfully.
1. 3-networks/envs/shared executed successfully.
1. Navigate out of the 3-networks/envs/shared repo `cd ..`.
1. Navigate into the [3-networks/envs/development](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/development) repo `cd development`.
1. The `base_private_service_cidr` local variable defined in this example has been changed to `base_private_service_cidr = "199.36.153.4/30"` in [3-networks/envs/development/main.tf](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/development/main.tf).
1. Subnets, including secondary ranges, in the base_shared_vpc module [3-networks/envs/development/main.tf](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/development/main.tf) from the CFT have been replaced by subnets from the example [app-foundation/3-networks/development/main.tf](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/app-foundation/3-networks/development/main.tf).
1. The `boa_networking.tf` file has been copied from [app-foundation/3-networks/development/boa_networking.tf](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/app-foundation/3-networks/development/boa_networking.tf) to the [3-Networks/envs/development](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/development) folder.
1. The `boa_networking.tfvars` file has been copied from [app-foundation/3-networks/development/boa_networking.tfvars](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/app-foundation/3-networks/development/boa_networking.tfvars) to the [3-Networks/envs/development](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/development) folder. The 'Tfvars for BoA shared VPC' section includes tfvars that reside in the CFT that must be updated. All other tfvars are new and required.
The outputs from the `outputs.tf` file have been copied from [app-foundation/3-networks/development/outputs.tf](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/app-foundation/3-networks/development/outputs.tf) to the CFT outputs file [3-Networks/envs/development/outputs.tf](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/development/outputs.tf).
1. Obtain the value for the access_context_manager_policy_id variable. Can be obtained by running `gcloud access-context-manager policies list --organization YOUR-ORGANIZATION_ID --format="value(name)"`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_name | The name of the external IP address. | `string` | `"mci-ip"` | yes |
| address\_type | Determines if the IP address will be internal or external. Only 'INTERNAL' or 'EXTERNAL' can be used. | `string` | `"EXTERNAL"` | no |
| description | Describes what the external IP address will be used for. | `string` | `"External IP for HTTP load balancing."` | no |
| policy\_action | Specify if you want to allow or deny traffic. | `string` | `"deny(403)"` | yes |
| policy\_description | Description of the security policy. | `string` | `"Cloud Armor policy to prevent cross-site scripting attacks."` | yes |
| policy\_expression | Textual representation of an expression in Common Expression Language syntax. | `string` | `"evaluatePreconfiguredExpr('xss-stable')"` | yes |
| policy\_name | Name of the Cloud Armor security policy. | `string` | `"cloud-armor-xss-policy"` | yes |
| policy\_priority | Priority level for Cloud Armor policy. Lower numbers have higher priority. | `number` | `"1000"` | yes |
| private\_services\_address\_name | The name of the private services address. | `string` | `"cloud-sql-subnet-vpc-peering-internal"` | no |

## Outputs

| Name | Description |
|------|-------------|
| external\_ip\_address | The external IP for HTTP load balancing. |
| private\_services\_address | The private services connection for Cloud SQL. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
