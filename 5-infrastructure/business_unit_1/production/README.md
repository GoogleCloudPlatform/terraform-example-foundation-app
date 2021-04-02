<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| boa\_gke\_project\_id | Project ID for GKE. Can be left blank if prjs deployed follow naming convention (Eg. prj-bu1-d-boa-gke-xxxx) | `string` | `""` | no |
| boa\_ops\_project\_id | Project ID for ops. Can be left blank if prjs deployed follow naming convention (Eg. prj-bu1-d-boa-gke-xxxx) | `string` | `""` | no |
| boa\_sec\_project\_id | Project ID for secrets. Can be left blank if prjs deployed follow naming convention (Eg. prj-bu1-d-boa-gke-xxxx) | `string` | `""` | no |
| boa\_sql\_project\_id | Project ID for SQL. Can be left blank if prjs deployed follow naming convention (Eg. prj-bu1-d-boa-gke-xxxx) | `string` | `""` | no |
| gcp\_shared\_vpc\_project\_id | The host project id of the shared VPC. Can be left blank if prjs deployed follow naming convention (Eg. prj-d-shared-base-xxxx) | `string` | `""` | no |
| gke\_cluster\_1\_cidr\_block | The primary IPv4 cidr block for the first GKE cluster. | `string` | `"172.16.2.0/28"` | no |
| gke\_cluster\_2\_cidr\_block | The primary IPv4 cidr block for the second GKE cluster. | `string` | `"172.16.0.16/28"` | no |
| gke\_mci\_cluster\_cidr\_block | The primary IPv4 cidr block for multi-cluster ingress (MCI). | `string` | `"172.16.3.0/28"` | no |
| location\_primary | The primary region for deployment, if not set default locations for each resource are taken from variables file | `string` | `"us-east1"` | no |
| location\_secondary | The secondary region for deployment, if not set default locations for each resource are taken from variables file | `string` | `"us-west1"` | no |
| parent\_folder | The parent folder or org for environments. | `string` | n/a | yes |
| terraform\_service\_account | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_cidr\_range | Self link of the bastion host |
| bastion\_hostname | Host name of the bastion |
| bastion\_ip\_address | Internal IP address of the bastion host |
| bastion\_service\_account\_email | Email address of the SA created for the bastion host |
| gke\_log\_export\_map | Outputs from the log export |
| gke\_outputs | Outputs for Cloud SQL instances |
| kms\_outputs | Outputs for KMS Keyrings and Keys |
| kms\_sa | KMS Service Account |
| logging\_destination\_map | Outputs from the destination |
| ops\_log\_export\_map | Outputs from the log export |
| sec\_log\_export\_map | Outputs from the log export |
| sql\_log\_export\_map | Outputs from the log export |
| sql\_outputs | The name for Cloud SQL instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
