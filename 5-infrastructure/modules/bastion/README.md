# Bastion Module
This module is a wrapper for [CFT Bastion Module](https://github.com/terraform-google-modules/terraform-google-bastion-host) and will generate a shielded bastion host vm connected to a shared VPC network.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_members | The emails of the members with access to the bastion server | `list(string)` | n/a | yes |
| bastion\_name | The name of the bastion server | `string` | n/a | yes |
| bastion\_region | The region of the GCP subnetwork for bastion services | `string` | n/a | yes |
| bastion\_service\_account\_name | The service account to be created for the bastion. | `string` | n/a | yes |
| bastion\_subnet | The name of the GCP subnetwork for bastion services | `string` | n/a | yes |
| bastion\_zone | The zone for the bastion VM | `string` | n/a | yes |
| network\_project\_id | The project id of the GCP subnetwork for bastion services | `string` | n/a | yes |
| project\_id | The Google Cloud project ID | `string` | n/a | yes |
| repo\_project\_id | The project where app repos exist | `string` | n/a | yes |
| vpc\_name | The name of the bastion VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cidr\_range | Internal IP address range of the bastion host |
| hostname | Host name of the bastion |
| ip\_address | Internal IP address of the bastion host |
| self\_link | Self link of the bastion host |
| service\_account\_email | Email address of the SA created for the bastion host |
| subnet\_name | Self link of the bastion host |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
