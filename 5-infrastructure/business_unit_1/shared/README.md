<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_cicd\_build\_sa | Service account email of the account to impersonate to run Terraform | `string` | n/a | yes |
| app\_cicd\_project\_id | Project ID for CICD Pipeline Project | `string` | n/a | yes |
| primary\_location | Region used for key-ring | `string` | `"us-east1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bin\_auth\_attestor\_names | Names of Attestors |
| bin\_auth\_attestor\_project\_id | Project ID where attestors get created |
| boa\_artifact\_repo | GAR Repo created to store BoA images |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
