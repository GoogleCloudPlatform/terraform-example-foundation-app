# SQL Module
This module is a wrapper for [CFT PostgreSQL Module](https://github.com/terraform-google-modules/terraform-google-sql-db/tree/master/modules/postgresql) to create a Google PostgreSQL CloudSQL instance and implement high availability settings.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_databases | Additional Databases | <pre>list(object({<br>    name      = string<br>    charset   = string<br>    collation = string<br>  }))</pre> | `[]` | no |
| admin\_password | The admin password | `string` | n/a | yes |
| admin\_user | The admin username | `string` | n/a | yes |
| authorized\_networks | CIDR Ranges of Secondary IP ranges for all GKE Cluster Subnets | `list(map(string))` | n/a | yes |
| database\_name | The database name | `string` | n/a | yes |
| database\_region | The database region | `string` | n/a | yes |
| database\_users | Additional Database Users | <pre>list(object({<br>    name     = string<br>    password = string<br>    host     = string<br>  }))</pre> | `[]` | no |
| database\_zone | The database zone | `string` | n/a | yes |
| project\_id | The GCP Project ID | `string` | n/a | yes |
| replica\_zones | The GCP Zones | <pre>object({<br>    zone1 = string<br>    zone2 = string<br>  })</pre> | n/a | yes |
| sql\_instance\_prefix | The instance name prefix, random string is added as suffix | `string` | n/a | yes |
| vpc\_self\_link | The self\_link of the VPC to be given private access | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| private\_ip\_address | n/a |
| sql\_instance\_name | The name for Cloud SQL instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
