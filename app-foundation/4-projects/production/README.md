<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alert\_pubsub\_topic | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` | `string` | `null` | no |
| alert\_spent\_percents | A list of percentages of the budget to alert on when threshold is exceeded | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| app\_cicd\_project\_id | Project ID for app cicd | `string` | n/a | yes |
| app\_infra\_pipeline\_cloudbuild\_sa | Cloud Build SA used for deploying infrastructure | `string` | n/a | yes |
| billing\_account | The ID of the billing account to associated this project with | `string` | n/a | yes |
| budget\_amount | The amount to use as the budget | `number` | `1000` | no |
| enable\_hub\_and\_spoke | Enable Hub-and-Spoke architecture. | `bool` | `false` | no |
| environment\_code | Short form of current running environment (e.g. d for development) | `string` | `"p"` | no |
| folder\_prefix | Name prefix to use for folders created. | `string` | `"fldr"` | no |
| org\_id | The organization id for the associated services | `string` | n/a | yes |
| parent\_folder | Optional - if using a folder for testing. | `string` | `""` | no |
| project\_prefix | Name prefix to use for projects created. | `string` | `"prj"` | no |
| shared\_vpc\_host\_project\_id | Host Project ID for the Shared VPC and Subnets | `string` | n/a | yes |
| shared\_vpc\_network\_name | Shared VPC Name | `string` | n/a | yes |
| terraform\_service\_account | Service account email of the account to impersonate to run Terraform | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| boa\_gke\_project\_id | Project ID for GKE Project |
| boa\_gsa\_sa\_email | SA email for boa-gsa service account |
| boa\_ops\_project\_id | Project ID for Ops Project |
| boa\_sec\_project\_id | Project ID for Secrets Project |
| boa\_sql\_project\_id | Project ID for SQL Project |
| terraform\_service\_account | Terraform Deployment SA for 5-infrastructure |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
