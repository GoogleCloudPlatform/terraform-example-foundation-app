# 3-networks/non-production

This is a terraform wrapper for [CFT 3-Networks/envs/non-production](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks/envs/non-production) and can be used to set up a base shared VPC with default NAT, baseline firewall rules, Cloud Armor, private service networking, and an external IP address for the Bank of Anthos example application in the non-production environment.

## Prerequisites

1. 0-bootstrap executed successfully.
1. 1-org executed successfully.
1. 2-environments/envs/non-production executed successfully.
1. 3-networks/envs/shared executed successfully.
1. The two local variables defined in this example are changed in [3-Networks/envs/non-production/main.tf](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/non-production/main.tf).
1. Subnets, including secondary ranges, in only the base_shared_vpc module [3-Networks/envs/non-production/main.tf](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/non-production/main.tf) from the CFT have been removed.
1. New subnets are added to the base_shared_vpc module [3-Networks/envs/non-production/main.tf](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/envs/non-production/main.tf) as shown in the example.
1. All additional resources, variables, and outputs from this terraform wrapper are populated and consistent with the 3-networks/envs/non-production environment.
1. Change boa_networking.tfvars.example to boa_networing.tfvars and update the contents to match your environment. The 'Tfvars for BoA shared VPC' section includes tfvars that reside in the CFT that must also be updated.  All others tfvars are new and required.
1. Obtain the value for the access_context_manager_policy_id variable. Can be obtained by running `gcloud access-context-manager policies list --organization YOUR-ORGANIZATION_ID --format="value(name)"`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_name | The name of the external IP address. | `string` | n/a | yes |
| address\_type | Determines if the IP address will be internal or external. Only "INTERNAL" or "EXTERNAL" can be used. | `string` | `"EXTERNAL"` | no |
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
| private\_services\_address | The private services connection for Cloud SQL |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
