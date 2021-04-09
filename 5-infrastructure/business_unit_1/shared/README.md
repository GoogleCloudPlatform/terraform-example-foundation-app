<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_cicd\_build\_sa | Service account email of the account to impersonate to run Terraform | `string` | n/a | yes |
| app\_cicd\_project\_id | Project ID for | `string` | n/a | yes |
| app\_cicd\_repos | A list of Cloud Source Repos to be created to hold app infra Terraform configs | `list(string)` | <pre>[<br>  "root-config-repo",<br>  "accounts",<br>  "transactions",<br>  "frontend"<br>]</pre> | no |
| attestor\_names | A list of Cloud Source Repos to be created to hold app infra Terraform configs | `list(string)` | <pre>[<br>  "build",<br>  "quality",<br>  "security"<br>]</pre> | no |
| cloudbuild\_yaml\_file\_name | Name of cloudbuild file | `string` | `"cloudbuild.yaml"` | no |
| primary\_location | Region used for key-ring | `string` | `"us-east1"` | no |
| terraform\_validator\_release | Default terraform-validator release. | `string` | `"2021-01-21"` | no |
| terraform\_version | Default terraform version. | `string` | `"0.13.6"` | no |
| terraform\_version\_sha256sum | sha256sum for default terraform version. | `string` | `"55f2db00b05675026be9c898bdd3e8230ff0c5c78dd12d743ca38032092abfc9"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bin\_auth\_attestor\_names | Names of Attestors |
| bin\_auth\_attestor\_project\_id | Project ID where attestors get created |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
