<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_members | The emails of the members with access to the bastion server. | `list(string)` | `[]` | no |
| bin\_auth\_attestor\_names | Binary Authorization Attestor Names set up in shared app\_cicd project | `list(string)` | <pre>[<br>  "build-attestor",<br>  "quality-attestor",<br>  "security-attestor"<br>]</pre> | no |
| bin\_auth\_attestor\_project\_id | Project id where binary attestors are created (app\_cicd project from shared) | `string` | n/a | yes |
| boa\_gke\_project\_id | Project ID for GKE | `string` | n/a | yes |
| boa\_ops\_project\_id | Project ID for ops | `string` | n/a | yes |
| boa\_sec\_project\_id | Project ID for secrets | `string` | n/a | yes |
| boa\_sql\_project\_id | Project ID for SQL | `string` | n/a | yes |
| enforce\_bin\_auth\_policy | Enable or Disable creation of binary authorization policy | `bool` | `false` | no |
| gcp\_shared\_vpc\_project\_id | The host project id of the shared VPC | `string` | n/a | yes |
| gke\_cluster\_1\_cidr\_block | The primary IPv4 cidr block for the first GKE cluster. | `string` | `"100.64.142.0/28"` | no |
| gke\_cluster\_2\_cidr\_block | The primary IPv4 cidr block for the second GKE cluster. | `string` | `"100.65.134.0/28"` | no |
| gke\_mci\_cluster\_cidr\_block | The primary IPv4 cidr block for multi-cluster ingress (MCI). | `string` | `"100.64.134.0/28"` | no |
| location\_primary | The primary region for deployment | `string` | `"us-east1"` | no |
| location\_secondary | The secondary region for deployment | `string` | `"us-west1"` | no |
| shared\_vpc\_name | The shared VPC network name | `string` | n/a | yes |
| sql\_admin\_password | Admin Password for SQL Instances. | `string` | `"admin"` | no |
| sql\_admin\_username | Admin Username for SQL Instances. | `string` | `"admin"` | no |
| terraform\_service\_account | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_hostname | Host name of the bastion |
| bastion\_ip\_address | Internal IP address of the bastion host |
| bastion\_service\_account\_email | Email address of the SA created for the bastion host |
| external\_ip\_address | The external IP for HTTP load balancing. |
| gke\_1\_cluster\_name | Cluster 1 Name |
| gke\_1\_master\_ipv4 | Cluster 1 Master IPV4 Address CIDR |
| gke\_1\_region | Cluster 1 Region |
| gke\_2\_cluster\_name | Cluster 2 Name |
| gke\_2\_master\_ipv4 | Cluster 2 Master IPV4 Address CIDR |
| gke\_2\_region | Cluster 2 Region |
| mci\_cluster\_name | MCI Cluster Name |
| mci\_master\_ipv4 | MCI Cluster Master IPV4 Address CIDR |
| mci\_region | MCI Cluster Region |
| sql\_1\_instance\_name | PostgreSQL Instance 1 Name |
| sql\_1\_ip\_address | PostgreSQL Instance 1 Private Ip |
| sql\_2\_instance\_name | PostgreSQL Instance 2 Name |
| sql\_2\_ip\_address | PostgreSQL Instance 2 Private Ip |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
