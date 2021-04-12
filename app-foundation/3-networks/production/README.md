# 3-networks/production

This is an additional Terraform configuration for [CFT 3-Networks/envs/production](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks/envs/production) and can be used to set up the subnets, additional firewall rules, Cloud Armor, private service networking, and an external IP address for the Bank of Anthos example application in the production environment.

## Prerequisites

1. 0-bootstrap executed successfully.
1. 1-org executed successfully.
1. 2-environments/envs/production executed successfully.
1. 3-networks/envs/shared executed successfully.
1. 3-networks/envs/non-production was updated successfully.
1. Navigate out of the 3-networks/envs/non-production repo `cd ..`.
1. Navigate into the [3-Networks/envs/production](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/production) repo `cd production`.
1. The two local variables - `environment_code = "prd"` and `base_private_service_cidr = "199.36.153.4/30"` - defined in this example are changed in [3-Networks/envs/production/main.tf](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/production/main.tf).
1. Subnets, including secondary ranges, in the base_shared_vpc module [3-Networks/envs/production/main.tf](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/production/main.tf) from the CFT have been removed.
1. The variables located in the `base_shared_vpc {}` section of `main.tf` are updated with values from the example:
    ```
    _default_region1="us-east1"
    _default_region2="us-west1"
    _enable_hub_and_spoke="true"
    _enable_hub_and_spoke_transitivity="true"
    _nat_enabled="true"
    _optional_firewall_rules_enabled="true"
    ```
1. The new subnets and secondary ranges are added to the base_shared_vpc module [3-Networks/envs/production/main.tf](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/production/main.tf) as shown in the example.
1. All new resources, variables, and outputs from this terraform configuration are added to the [3-Networks/envs/production](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/production) folder and consistent with the 3-networks/envs/production environment.
1. Change boa_networking.tfvars.example to boa_networking.tfvars and update the contents to match your environment. The 'Tfvars for BoA shared VPC' section includes tfvars that reside in the CFT that must be updated. All other tfvars are new and required.
1. Obtain the value for the access_context_manager_policy_id variable. Can be obtained by running `gcloud access-context-manager policies list --organization YOUR-ORGANIZATION_ID --format="value(name)"`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_name | The name of the external IP address. | `string` | n/a | yes |
| address\_type | Determines if the IP address will be internal or external. Only 'INTERNAL' or 'EXTERNAL' can be used. | `string` | `"EXTERNAL"` | no |
| description | Describes what the external IP address will be used for. | `string` | `"External IP for HTTP load balancing."` | no |
| policy\_action | Specify if you want to allow or deny traffic. | `string` | n/a | yes |
| policy\_description | Description of the security policy. | `string` | n/a | yes |
| policy\_expression | Textual representation of an expression in Common Expression Language syntax. | `string` | n/a | yes |
| policy\_name | Name of the Cloud Armor security policy. | `string` | n/a | yes |
| policy\_priority | Priority level for Cloud Armor policy. Lower numbers have higher priority. | `number` | n/a | yes |
| private\_services\_address\_name | The name of the private services address. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| external\_ip\_address | The external IP for HTTP load balancing. |
| private\_services\_address | The private services connection for Cloud SQL. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
