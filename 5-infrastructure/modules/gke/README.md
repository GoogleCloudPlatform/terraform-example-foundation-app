# GKE Module
This module is a wrapper for [CFT GKE Safer-Cluster Module](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/safer-cluster) defines an opinionated setup of GKE cluster.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | The name of the GKE cluster | `string` | n/a | yes |
| master\_authorized\_networks | n/a | <pre>list(object({<br>    cidr_block   = string,<br>    display_name = string<br>  }))</pre> | n/a | yes |
| master\_ipv4\_cidr\_block | The IPv4 cidr block for the masters | `string` | n/a | yes |
| network\_name | The name of the VPC network | `string` | n/a | yes |
| network\_project\_id | The project id of the VPC subnetwork | `string` | n/a | yes |
| node\_pools | List of Node Pool objects | `list(map(string))` | n/a | yes |
| project\_id | The Google Cloud project ID | `string` | n/a | yes |
| range\_name\_pods | The name of the subnet secondary range for pods | `string` | n/a | yes |
| range\_name\_services | The name of the subnet secondary range for services | `string` | n/a | yes |
| region | The Google Cloud region, e.g. us-central1 | `string` | n/a | yes |
| subnetwork\_name | The name of the VPC subnetwork | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | Cluster ca certificate (base64 encoded) |
| endpoint | Cluster endpoint |
| horizontal\_pod\_autoscaling\_enabled | Whether horizontal pod autoscaling enabled |
| http\_load\_balancing\_enabled | Whether http load balancing enabled |
| location | Cluster location (region if regional cluster, zone if zonal cluster) |
| logging\_service | Logging service used |
| master\_authorized\_networks\_config | Networks from which access to master is permitted |
| master\_ipv4\_cidr\_block | The IP range in CIDR notation used for the hosted master network |
| master\_version | Current master kubernetes version |
| min\_master\_version | Minimum master kubernetes version |
| monitoring\_service | Monitoring service used |
| name | Cluster name |
| network\_policy\_enabled | Whether network policy enabled |
| node\_pools\_names | List of node pools names |
| node\_pools\_versions | List of node pools versions |
| peering\_name | The name of the peering between this cluster and the Google owned VPC. |
| region | Cluster region |
| service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| type | Cluster type (regional / zonal) |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
