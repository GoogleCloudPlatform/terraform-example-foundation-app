# 3-networks/production

This is an additional Terraform configuration for [CFT 3-Networks/envs/production](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks/envs/production) and can be used to set up the subnets, additional firewall rules, and private service networking for the Bank of Anthos example application in the production environment.

## Prerequisites

1. 0-bootstrap executed successfully.
1. 1-org executed successfully.
1. 2-environments/envs/production executed successfully.
1. 3-networks/envs/shared executed successfully.
1. 3-networks/envs/non-production was updated successfully.
1. Navigate out of the 3-networks/envs/non-production repo `cd ..`.
1. Navigate into the [3-networks/envs/production](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/production) repo `cd production`.
1. The `base_private_service_cidr` local variable defined in this example has been changed to `base_private_service_cidr = "199.36.153.4/30"` in [3-networks/envs/production/main.tf](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/production/main.tf).
1. Subnets, including secondary ranges, in the base_shared_vpc module [3-networks/envs/production/main.tf](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/production/main.tf) from the CFT have been replaced by subnets from the example [app-foundation/3-networks/production/main.tf](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/app-foundation/3-networks/production/main.tf).
1. The `boa_networking.tf` file has been copied from [app-foundation/3-networks/production/boa_networking.tf](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/app-foundation/3-networks/production/boa_networking.tf) to the [3-Networks/envs/production](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/production) folder.
1. The `boa_networking.tfvars` file has been copied from [app-foundation/3-networks/production/boa_networking.tfvars](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/app-foundation/3-networks/production/boa_networking.tfvars) to the [3-Networks/envs/production](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/production) folder. The 'Tfvars for BoA shared VPC' section includes tfvars that reside in the CFT that must be updated.
1. The outputs from the `outputs.tf` file have been copied from [app-foundation/3-networks/production/outputs.tf](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/tree/main/app-foundation/3-networks/production/outputs.tf) to the CFT outputs file [3-Networks/envs/production/outputs.tf](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/production/outputs.tf).
1. Obtain the value for the access_context_manager_policy_id variable. Can be obtained by running `gcloud access-context-manager policies list --organization YOUR-ORGANIZATION_ID --format="value(name)"`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Outputs

| Name | Description |
|------|-------------|
| private\_services\_address | The private services connection for Cloud SQL. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
