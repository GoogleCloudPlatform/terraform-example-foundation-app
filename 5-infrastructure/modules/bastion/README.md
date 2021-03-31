# Bastion

## Purpose

Create a Bastion VM using the `terraform-google-modules/bastion-host` module. All values for the module are passed as variables with one exception; the network tag is set to "bastion"

> Reference: [terraform-google-bastion-host](https://github.com/terraform-google-modules/terraform-google-bastion-host)

## Inputs

| Variable | Type |Description|
| --- | --- | --- |
| bastion_members | list(string) | accounts enabled with Bastion access |
| bastion_name | string | The name of the Bastion |
| bastion_region | string | GCP region
| bastion_service_account_email | string | Service Account |
| bastion_subnet | string | The name of the GCP subnetwork |
| bastion_zone | string | The Bastion Zone |
| project_id | string | The GCP Project |
| vpc_name | string | The GCP VPC name |

## Data

### bastion_subnet

| Resource | Source Variable |Description|
| --- | --- | --- |
| project | var.project_id | The VPC project or the Shared VPC Host Project ID |
| name | var.bastion_subnet | The bastion subnet |
| region | var.bastion_region | The region of the VPC subnetwork

### vpc

| Resource | Source Variable |Description|
| --- | --- | --- |
| project | var.project_id | The VPC project or the Shared VPC Host Project ID |
| name | var.vpc_name | The bastion VPC name or Shared VPC Network Name |

## Outputs

| Name | Description |
| --- | ---|
| hostname | Host name of the bastion |
| ip_address | Internal IP address of the bastion host |
| self_link | Self link of the bastion host |
| service_account | The email for the service account created for the bastion host |
