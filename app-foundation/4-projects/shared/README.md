<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alert\_pubsub\_topic | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` | `string` | `null` | no |
| alert\_spent\_percents | A list of percentages of the budget to alert on when threshold is exceeded | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| billing\_account | The ID of the billing account to associated this project with | `string` | n/a | yes |
| budget\_amount | The amount to use as the budget | `number` | `1000` | no |
| folder\_prefix | Name prefix to use for folders created. | `string` | `"fldr"` | no |
| org\_id | The organization id for the associated services | `string` | n/a | yes |
| parent\_folder | Optional - if using a folder for testing. | `string` | `""` | no |
| primary\_location | Location region to create resources | `string` | `"us-east1"` | no |
| project\_prefix | Name prefix to use for projects created. | `string` | `"prj"` | no |
| terraform\_service\_account | Service account email of the account to impersonate to run Terraform | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| app\_cicd\_build\_sa | n/a |
| app\_cicd\_project\_id | n/a |
| app\_infra\_cloudbuild\_project\_id | n/a |
| app\_infra\_pipeline\_cloudbuild\_sa | n/a |
| app\_infra\_repos | CSRs to store source code |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
