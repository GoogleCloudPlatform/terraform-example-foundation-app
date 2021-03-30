# Bastion

## Purpose

Create a Bastion VM using the `terraform-google-modules/bastion-host` module. All values for the module are passed as variables with one exception; the network tag is set to "bastion"

> Reference: [terraform-google-bastion-host](https://github.com/terraform-google-modules/terraform-google-bastion-host)

## Unit Tests

```
make usc1-a # Create bastion
make destroy-usc1-a # Destroy bastion
```

> You will need to update the tfvars files to ensure the project id is set to a project you can access.

### Dependencies

The following terraform workspaces *must* exist:

* central1

## Calling

```
module "test-bastion" {
    source = "./modules/bastion"
    project_id = "bastion-project"
    bastion_members = []
    bastion_name = "bastion"
    bastion_region = "us-central1"
    bastion_service_account_email = "xxx-compute@xxx"
    bastion_subnet = "bastion-subnet"
    bastion_zone = "us-central1-a"
    vpc_name = "boa-vpc"
}

output "service_account" {
  description = "The email for the service account created for the bastion host"
  value       = module.test-bastion.service_account
}

output "hostname" {
  description = "Host name of the bastion"
  value       = module.test-bastion.hostname
}

output "ip_address" {
  description = "Internal IP address of the bastion host"
  value       = module.test-bastion.ip_address
}

output "self_link" {
  description = "Self link of the bastion host"
  value       = module.test-bastion.self_link
}
```

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
| project | var.project_id | The bastion project |
| name | var.bastion_subnet | The bastion subnet |
| region | var.bastion_region | The region of the VPC subnetwork

### vpc

| Resource | Source Variable |Description|
| --- | --- | --- |
| project | var.project_id | The bastion project |
| name | var.vpc_name | The bastion VPC name |

## Outputs

| Name | Description |
| --- | ---|
| hostname | Host name of the bastion |
| ip_address | Internal IP address of the bastion host |
| self_link | Self link of the bastion host |
| service_account | The email for the service account created for the bastion host |
