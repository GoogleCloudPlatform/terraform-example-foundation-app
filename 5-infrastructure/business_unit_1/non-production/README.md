<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| boa\_gke\_project\_id | Project ID for GKE. Can be left blank if prjs deployed follow naming convention (Eg. prj-bu1-d-boa-gke-xxxx) | `string` | n/a | yes |
| boa\_ops\_project\_id | Project ID for ops. Can be left blank if prjs deployed follow naming convention (Eg. prj-bu1-d-boa-gke-xxxx) | `string` | n/a | yes |
| boa\_sec\_project\_id | Project ID for secrets. Can be left blank if prjs deployed follow naming convention (Eg. prj-bu1-d-boa-gke-xxxx) | `string` | n/a | yes |
| boa\_sql\_project\_id | Project ID for SQL. Can be left blank if prjs deployed follow naming convention (Eg. prj-bu1-d-boa-gke-xxxx) | `string` | n/a | yes |
| gcp\_shared\_vpc\_project\_id | The host project id of the shared VPC. Can be left blank if prjs deployed follow naming convention (Eg. prj-d-shared-base-xxxx) | `string` | n/a | yes |
| gke\_cluster\_1\_cidr\_block | The primary IPv4 cidr block for the first GKE cluster. | `string` | n/a | yes |
| gke\_cluster\_2\_cidr\_block | The primary IPv4 cidr block for the second GKE cluster. | `string` | n/a | yes |
| gke\_mci\_cluster\_cidr\_block | The primary IPv4 cidr block for multi-cluster ingress (MCI). | `string` | n/a | yes |
| location\_primary | The primary region for deployment, if not set default locations for each resource are taken from variables file | `string` | `"us-east1"` | no |
| location\_secondary | The secondary region for deployment, if not set default locations for each resource are taken from variables file | `string` | `"us-west1"` | no |
| parent\_folder | The parent folder or org for environments. | `string` | n/a | yes |
| shared\_vpc\_name | The shared VPC network name | `string` | n/a | yes |
| terraform\_service\_account | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_cidr\_range | Self link of the bastion host |
| bastion\_hostname | Host name of the bastion |
| bastion\_ip\_address | Internal IP address of the bastion host |
| bastion\_service\_account\_email | Email address of the SA created for the bastion host |
| gke\_outputs | Outputs for Cloud SQL instances |
| kms\_outputs | Outputs for KMS Keyrings and Keys |
| kms\_sa | KMS Service Account |
| sql\_outputs | The name for Cloud SQL instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
