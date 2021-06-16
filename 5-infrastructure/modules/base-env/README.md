# Base Env Module
This module creates the resources needed for the BOA Deloyment.

The module provisions the following resources
- 3 GKE Clusters
    - Cluster1 in Primary Region
    - CLuster2 in Secondary Region
    - MCI Cluster is Primary Region
- Bastion Host VM in the Secondary Region
- 2 Postgres CLoudSQL instances in primary and secondary region respectively
- Secret to store CloudSQL Admin Password
- 4 KMS Keyrings and Keys
    - 2 KMS Keyrings and Keys for GKE, one in each region
    - 2 KMS Keyrings and Keys for CloudSQL, one in each region
- Service Account for KMS to own/manage the Keyrings and Keys
- Service Account for Bastion VM with roles to install Anthos Service Mesh
- 4 Log Sinks, one in each project
- Log Sink Destination Storage Bucket that Log Sinks write logs to
- Cloud Armor policy to prevent cross-site scripting attacks
- External IP address for HTTP load balancing

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_members | The emails of the members with access to the bastion server. | `list(string)` | `[]` | no |
| bastion\_subnet\_name | The name of the subnet for the shared VPC. | `string` | `"bastion-host-subnet"` | no |
| bastion\_zone | The zone for the bastion VM in primary region. | `string` | `"us-west1-b"` | no |
| bin\_auth\_attestor\_names | Binary Authorization Attestor Names set up in shared app\_cicd project. | `list(string)` | `[]` | no |
| bin\_auth\_attestor\_project\_id | Project Id where binary attestors are created. | `string` | n/a | yes |
| boa\_gke\_project\_id | Project ID for GKE. | `string` | n/a | yes |
| boa\_ops\_project\_id | Project ID for ops. | `string` | n/a | yes |
| boa\_sec\_project\_id | Project ID for secrets. | `string` | n/a | yes |
| boa\_sql\_project\_id | Project ID for SQL. | `string` | n/a | yes |
| enforce\_bin\_auth\_policy | Enable or Disable creation of binary authorization policy. | `bool` | `false` | no |
| env | The environment to prepare (dev/npd/prd). | `string` | n/a | yes |
| folder\_prefix | Name prefix to use for folders created. | `string` | `"fldr"` | no |
| gcp\_shared\_vpc\_project\_id | The host project id of the shared VPC. | `string` | n/a | yes |
| gke\_cluster\_1\_cidr\_block | The primary IPv4 cidr block for the first GKE cluster. | `string` | n/a | yes |
| gke\_cluster\_1\_range\_name\_pods | The name of the pods IP range for the first GKE cluster. | `string` | `"pod-ip-range"` | no |
| gke\_cluster\_1\_range\_name\_services | The name of the services IP range for the first GKE cluster. | `string` | `"services-ip-range"` | no |
| gke\_cluster\_1\_subnet\_name | The name of the subnet for the first GKE cluster. | `string` | `"gke-cluster1-subnet"` | no |
| gke\_cluster\_2\_cidr\_block | The primary IPv4 cidr block for the second GKE cluster. | `string` | n/a | yes |
| gke\_cluster\_2\_range\_name\_pods | The name of the pods IP range for the second GKE cluster. | `string` | `"pod-ip-range"` | no |
| gke\_cluster\_2\_range\_name\_services | The name of the services IP range for the second GKE cluster. | `string` | `"services-ip-range"` | no |
| gke\_cluster\_2\_subnet\_name | The name of the subnet for the second GKE cluster. | `string` | `"gke-cluster2-subnet"` | no |
| gke\_mci\_cluster\_cidr\_block | The primary IPv4 cidr block for multi-cluster ingress (MCI). | `string` | n/a | yes |
| gke\_mci\_cluster\_range\_name\_pods | The name of the pods IP range for multi-cluster ingress (MCI). | `string` | `"pod-ip-range"` | no |
| gke\_mci\_cluster\_range\_name\_services | The name of the services IP range for multi-cluster ingress (MCI). | `string` | `"services-ip-range"` | no |
| gke\_mci\_cluster\_subnet\_name | The name of the subnet for multi-cluster ingress (MCI). | `string` | `"mci-config-subnet"` | no |
| location\_primary | The primary region for deployment, if not set default locations for each resource are taken from variables file. | `string` | `"us-east1"` | no |
| location\_secondary | The secondary region for deployment, if not set default locations for each resource are taken from variables file. | `string` | `"us-west1"` | no |
| max\_pods\_per\_node | The maximum number of pods to schedule per node | `number` | `64` | no |
| project\_prefix | Name prefix to use for projects created. | `string` | `"prj"` | no |
| shared\_vpc\_name | The shared VPC network name. | `string` | n/a | yes |
| sql\_admin\_password | Admin Password for SQL Instances. | `string` | `"admin"` | no |
| sql\_admin\_username | Admin Username for SQL Instances. | `string` | `"admin"` | no |
| sql\_database\_replication\_region | SQL Instance Replica Region. | `string` | `"us-central1"` | no |
| terraform\_service\_account | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_hostname | Host name of the bastion. |
| bastion\_ip\_address | Internal IP address of the bastion host. |
| bastion\_service\_account\_email | Email address of the SA created for the bastion host. |
| external\_ip\_address | The external IP for HTTP load balancing. |
| gke\_outputs | Outputs for Cloud SQL instances. |
| kms\_outputs | Outputs for KMS Keyrings and Keys. |
| sql\_outputs | Outputs for Cloud SQL instances. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
