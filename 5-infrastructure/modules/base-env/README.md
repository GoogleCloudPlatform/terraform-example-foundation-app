# Base Env Module
This module creates the resources needed for the BOA Deloyment.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_members | The names of the members of the bastion server. | `list(string)` | `[]` | no |
| bastion\_subnet\_name | The name of the subnet for the shared VPC. | `string` | `"bastion-host-subnet"` | no |
| bastion\_subnet\_region | The region the shared VPC will be located in. Only if Primary region value, is not given | `string` | `"us-east1"` | no |
| bastion\_zone | The zone for the bastion VM in primary region | `string` | `"us-west1-b"` | no |
| boa\_gke\_project\_id | Project ID for GKE. | `string` | n/a | yes |
| boa\_ops\_project\_id | Project ID for ops. | `string` | n/a | yes |
| boa\_sec\_project\_id | Project ID for secrets. | `string` | n/a | yes |
| boa\_sql\_project\_id | Project ID for SQL. | `string` | n/a | yes |
| business\_unit | A short form of the business unit level projects within the Google Cloud organization (ex. bu1). | `string` | `"bu1"` | no |
| env | The environment to prepare (ex. development). | `string` | n/a | yes |
| env\_short | The environment to prepare (ex. dev). | `string` | n/a | yes |
| environment\_code | A short form of the folder level resources (environment) within the Google Cloud organization (ex. d). | `string` | n/a | yes |
| folder\_prefix | Name prefix to use for folders created. | `string` | `"fldr"` | no |
| gcp\_shared\_vpc\_project\_id | The host project id of the shared VPC. | `string` | n/a | yes |
| gke\_cluster\_1\_cidr\_block | The primary IPv4 cidr block for the first GKE cluster. | `string` | n/a | yes |
| gke\_cluster\_1\_location | The location of the first GKE cluster.  Only if Primary region value, is not given | `string` | `"us-east1"` | no |
| gke\_cluster\_1\_machine\_type | The type of VM that will be used for the first GKE cluster (ex. e2-micro). | `string` | `"e2-standard-4"` | no |
| gke\_cluster\_1\_range\_name\_pods | The name of the pods IP range for the first GKE cluster. | `string` | `"pod-ip-range"` | no |
| gke\_cluster\_1\_range\_name\_services | The name of the services IP range for the first GKE cluster. | `string` | `"services-ip-range"` | no |
| gke\_cluster\_1\_subnet\_name | The name of the subnet for the first GKE cluster. | `string` | `"gke-cluster1-subnet"` | no |
| gke\_cluster\_2\_cidr\_block | The primary IPv4 cidr block for the second GKE cluster. | `string` | n/a | yes |
| gke\_cluster\_2\_location | The location of the second GKE cluster.  Only if Secondary region value, is not given | `string` | `"us-west1"` | no |
| gke\_cluster\_2\_machine\_type | The type of VM that will be used for the second GKE cluster (ex. e2-micro). | `string` | `"e2-standard-4"` | no |
| gke\_cluster\_2\_range\_name\_pods | The name of the pods IP range for the second GKE cluster. | `string` | `"pod-ip-range"` | no |
| gke\_cluster\_2\_range\_name\_services | The name of the services IP range for the second GKE cluster. | `string` | `"services-ip-range"` | no |
| gke\_cluster\_2\_subnet\_name | The name of the subnet for the second GKE cluster. | `string` | `"gke-cluster2-subnet"` | no |
| gke\_mci\_cluster\_cidr\_block | The primary IPv4 cidr block for multi-cluster ingress (MCI). | `string` | n/a | yes |
| gke\_mci\_cluster\_location | The location for multi-cluster ingress (MCI). Only if primary region value, is not given | `string` | `"us-east1"` | no |
| gke\_mci\_cluster\_machine\_type | The type of VM that will be used for multi-cluster ingress (MCI). | `string` | `"e2-standard-2"` | no |
| gke\_mci\_cluster\_range\_name\_pods | The name of the pods IP range for multi-cluster ingress (MCI). | `string` | `"pod-ip-range"` | no |
| gke\_mci\_cluster\_range\_name\_services | The name of the services IP range for multi-cluster ingress (MCI). | `string` | `"services-ip-range"` | no |
| gke\_mci\_cluster\_subnet\_name | The name of the subnet for multi-cluster ingress (MCI). | `string` | `"mci-config-subnet"` | no |
| kms\_location\_1 | The location of the first set of GKE, SQL - KMS keyring and keys. Only if Primary region value, is not given | `string` | `"us-east1"` | no |
| kms\_location\_2 | The location of the second set of GKE, SQL - KMS keyring and keys. Only if Secondary region value, is not given | `string` | `"us-west1"` | no |
| location\_primary | The primary region for deployment, if not set default locations for each resource are taken from variables file | `string` | `"us-east1"` | no |
| location\_secondary | The secondary region for deployment, if not set default locations for each resource are taken from variables file | `string` | `"us-west1"` | no |
| log\_storage\_bucket\_location | The region the storage bucket for logs is located. | `string` | `"US-WEST1"` | no |
| log\_storage\_bucket\_project | The project that will contain the storage bucket for logs, if not set, OPS project is taken by default | `string` | `""` | no |
| parent\_folder | The parent folder or org for environments. | `string` | n/a | yes |
| project\_prefix | Name prefix to use for projects created. | `string` | `"prj"` | no |
| sql\_1\_database\_region | The location of the SQL database. Only if primary region value, is not given | `string` | `"us-east1"` | no |
| sql\_2\_database\_region | The location of the 2nd SQL database. Only if Secondary region value, is not given | `string` | `"us-west1"` | no |
| sql\_instance\_defaults | Map of sql instance variables, leave database\_region empty to use primary and secondary regions automatically | `map` | <pre>{<br>  "sql_1": {<br>    "additional_databases": [],<br>    "admin_password": "foobar",<br>    "admin_user": "testuser",<br>    "database_name": "ledger-db",<br>    "database_region": "",<br>    "database_users": [],<br>    "database_zone": "us-east1-c",<br>    "replica_zones": {<br>      "zone1": "us-central1-a",<br>      "zone2": "us-central1-c",<br>      "zone3": "us-central1-f"<br>    }<br>  },<br>  "sql_2": {<br>    "additional_databases": [],<br>    "admin_password": "foobar",<br>    "admin_user": "testuser",<br>    "database_name": "accounts-db",<br>    "database_region": "",<br>    "database_users": [],<br>    "database_zone": "us-west1-a",<br>    "replica_zones": {<br>      "zone1": "us-central1-a",<br>      "zone2": "us-central1-c",<br>      "zone3": "us-central1-f"<br>    }<br>  }<br>}</pre> | no |
| terraform\_service\_account | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_cidr\_range | Self link of the bastion host |
| bastion\_hostname | Host name of the bastion |
| bastion\_ip\_address | Internal IP address of the bastion host |
| bastion\_self\_link | Self link of the bastion host |
| bastion\_service\_account\_email | Email address of the SA created for the bastion host |
| bastion\_subnet\_name | Self link of the bastion host |
| cluster\_1\_ca\_certificate | Cluster ca certificate (base64 encoded) |
| cluster\_1\_endpoint | Cluster endpoint |
| cluster\_1\_horizontal\_pod\_autoscaling\_enabled | Whether horizontal pod autoscaling enabled |
| cluster\_1\_http\_load\_balancing\_enabled | Whether http load balancing enabled |
| cluster\_1\_location | Cluster location (region if regional cluster, zone if zonal cluster) |
| cluster\_1\_logging\_service | Logging service used |
| cluster\_1\_master\_authorized\_networks\_config | Networks from which access to master is permitted |
| cluster\_1\_master\_ipv4\_cidr\_block | The IP range in CIDR notation used for the hosted master network |
| cluster\_1\_monitoring\_service | Monitoring service used |
| cluster\_1\_name | Cluster name |
| cluster\_1\_network\_policy\_enabled | Whether network policy enabled |
| cluster\_1\_node\_pools\_names | List of node pools names |
| cluster\_1\_node\_pools\_versions | List of node pools versions |
| cluster\_1\_peering\_name | The name of the peering between this cluster and the Google owned VPC. |
| cluster\_1\_region | Cluster region |
| cluster\_1\_service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| cluster\_1\_type | Cluster type (regional / zonal) |
| cluster\_1\_zones | List of zones in which the cluster resides |
| cluster\_2\_ca\_certificate | Cluster ca certificate (base64 encoded) |
| cluster\_2\_endpoint | Cluster endpoint |
| cluster\_2\_horizontal\_pod\_autoscaling\_enabled | Whether horizontal pod autoscaling enabled |
| cluster\_2\_http\_load\_balancing\_enabled | Whether http load balancing enabled |
| cluster\_2\_location | Cluster location (region if regional cluster, zone if zonal cluster) |
| cluster\_2\_logging\_service | Logging service used |
| cluster\_2\_master\_authorized\_networks\_config | Networks from which access to master is permitted |
| cluster\_2\_master\_ipv4\_cidr\_block | The IP range in CIDR notation used for the hosted master network |
| cluster\_2\_monitoring\_service | Monitoring service used |
| cluster\_2\_name | Cluster name |
| cluster\_2\_network\_policy\_enabled | Whether network policy enabled |
| cluster\_2\_node\_pools\_names | List of node pools names |
| cluster\_2\_node\_pools\_versions | List of node pools versions |
| cluster\_2\_peering\_name | The name of the peering between this cluster and the Google owned VPC. |
| cluster\_2\_region | Cluster region |
| cluster\_2\_service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| cluster\_2\_type | Cluster type (regional / zonal) |
| cluster\_2\_zones | List of zones in which the cluster resides |
| gke\_log\_export\_map | Outputs from the log export module |
| kms\_gke\_1\_keyring | Self link of the keyring. |
| kms\_gke\_1\_keyring\_name | Name of the keyring. |
| kms\_gke\_1\_keyring\_resource | Keyring resource. |
| kms\_gke\_1\_keys | Map of key name => key self link. |
| kms\_gke\_2\_keyring | Self link of the keyring. |
| kms\_gke\_2\_keyring\_name | Name of the keyring. |
| kms\_gke\_2\_keyring\_resource | Keyring resource. |
| kms\_gke\_2\_keys | Map of key name => key self link. |
| kms\_sql\_1\_keyring | Self link of the keyring. |
| kms\_sql\_1\_keyring\_name | Name of the keyring. |
| kms\_sql\_1\_keyring\_resource | Keyring resource. |
| kms\_sql\_1\_keys | Map of key name => key self link. |
| kms\_sql\_2\_keyring | Self link of the keyring. |
| kms\_sql\_2\_keyring\_name | Name of the keyring. |
| kms\_sql\_2\_keyring\_resource | Keyring resource. |
| kms\_sql\_2\_keys | Map of key name => key self link. |
| logging\_destination\_map | Outputs from the destination module |
| mci\_cluster\_ca\_certificate | Cluster ca certificate (base64 encoded) |
| mci\_cluster\_endpoint | Cluster endpoint |
| mci\_cluster\_horizontal\_pod\_autoscaling\_enabled | Whether horizontal pod autoscaling enabled |
| mci\_cluster\_http\_load\_balancing\_enabled | Whether http load balancing enabled |
| mci\_cluster\_location | Cluster location (region if regional cluster, zone if zonal cluster) |
| mci\_cluster\_logging\_service | Logging service used |
| mci\_cluster\_master\_authorized\_networks\_config | Networks from which access to master is permitted |
| mci\_cluster\_master\_ipv4\_cidr\_block | The IP range in CIDR notation used for the hosted master network |
| mci\_cluster\_monitoring\_service | Monitoring service used |
| mci\_cluster\_name | Cluster name |
| mci\_cluster\_network\_policy\_enabled | Whether network policy enabled |
| mci\_cluster\_node\_pools\_names | List of node pools names |
| mci\_cluster\_node\_pools\_versions | List of node pools versions |
| mci\_cluster\_peering\_name | The name of the peering between this cluster and the Google owned VPC. |
| mci\_cluster\_region | Cluster region |
| mci\_cluster\_service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| mci\_cluster\_type | Cluster type (regional / zonal) |
| mci\_cluster\_zones | List of zones in which the cluster resides |
| ops\_log\_export\_map | Outputs from the log export module |
| sec\_log\_export\_map | Outputs from the log export module |
| sql\_log\_export\_map | Outputs from the log export module |
| sql\_outputs | The name for Cloud SQL instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
