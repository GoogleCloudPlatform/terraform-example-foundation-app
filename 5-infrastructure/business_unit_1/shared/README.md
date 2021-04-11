<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_cicd\_build\_sa | Service account email of the account to impersonate to run Terraform | `string` | n/a | yes |
| app\_cicd\_project\_id | Project ID for CICD Pipeline Project | `string` | n/a | yes |
| app\_cicd\_repos | A list of Cloud Source Repos to be created to hold app infra Terraform configs | `list(string)` | <pre>[<br>  "root-config-repo",<br>  "accounts",<br>  "transactions",<br>  "frontend"<br>]</pre> | no |
| attestor\_names | A list of Cloud Source Repos to be created to hold app infra Terraform configs | `list(string)` | <pre>[<br>  "build",<br>  "quality",<br>  "security"<br>]</pre> | no |
| cloudbuild\_yaml\_file\_name | Name of cloudbuild file | `string` | `"cloudbuild.yaml"` | no |
| primary\_location | Region used for key-ring | `string` | `"us-east1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bin\_auth\_attestor\_names | Names of Attestors |
| bin\_auth\_attestor\_project\_id | Project ID where attestors get created |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
