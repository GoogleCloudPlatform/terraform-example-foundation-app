# KMS Module
This module is a wrapper for [CFT KMS Module](https://github.com/terraform-google-modules/terraform-google-kms) that allows managing a keyring, zero or more keys in the keyring, and IAM role bindings on individual keys..

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| key\_protection\_level | set the protection level. | `string` | `"HSM"` | no |
| keyring | Keyring name. | `string` | n/a | yes |
| keys | Key names. | `list(string)` | `[]` | no |
| location | Location for the keyring. | `string` | `"us"` | no |
| owners | Owners for keys declared in set\_owners. | `list(string)` | `[]` | no |
| prevent\_destroy | set the prevent\_destroy lifecycle. | `string` | `"true"` | no |
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| keyring | Self link of the keyring. |
| keyring\_name | Name of the keyring. |
| keyring\_resource | Keyring resource. |
| keys | Map of key name => key self link. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
