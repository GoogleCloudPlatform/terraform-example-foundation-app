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
| bastion\_hostname | Host name of the bastion |
| bastion\_ip\_address | Internal IP address of the bastion host |
| bastion\_service\_account\_email | Email address of the SA created for the bastion host |
| gke\_1\_cluster\_name | Cluster 1 Name |
| gke\_1\_master\_ipv4 | Cluster 1 Master IPV4 Address CIDR |
| gke\_1\_region | Cluster 1 Region |
| gke\_2\_cluster\_name | Cluster 2 Name |
| gke\_2\_master\_ipv4 | Cluster 2 Master IPV4 Address CIDR |
| gke\_2\_region | Cluster 2 Region |
| kms\_outputs | Outputs for KMS Keyrings and Keys |
| kms\_sa | KMS Service Account |
| mci\_cluster\_name | MCI Cluster Name |
| mci\_master\_ipv4 | MCI Cluster Master IPV4 Address CIDR |
| mci\_region | MCI Cluster Region |
| sql\_1\_instance\_name | PostgreSQL Instance 1 Name |
| sql\_1\_ip\_address | PostgreSQL Instance 1 Private Ip |
| sql\_2\_instance\_name | PostgreSQL Instance 2 Name |
| sql\_2\_ip\_address | PostgreSQL Instance 2 Private Ip |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
