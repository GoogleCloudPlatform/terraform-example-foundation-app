# 3-networks-extension

This is an additional Terraform configuration for [example-foundation 3-Networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks) and is used to set up the subnets, additional firewall rules for the Bank of Anthos example application across dev/non-prod/prod environments.

## Prerequisites

1. 0-bootstrap executed successfully.
1. 1-org executed successfully.
1. 2-environments/envs/ executed successfully.

## Order of Execution

1. Run merge_3-networks.sh
1. Follow steps in [example_foundation 3-Networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks/README.md)

## Steps performed in bash script

1. Clone [example_foundation 3-Networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks)
1. Merge files from 3-networks-extensions/envs into 3-networks/envs for the respective environments
1. Change Primary Region in [example_foundation 3-networks/common.auto.tfvars](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/common.auto.example.tfvars) from us-central1 to us-east1 to be consistent with BOA 4-projects and 5-infrastructure
1. Remove Base Shared VPC defined in main.tf of [example_foundation 3-Networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks) as boa_vpc.tf replaces it with new subnets.

## Local Run Troubleshooting

1. Ensure you have given execute permissions `chmod +x merge_3-networks.sh`
1. If you get '\r Error' you can use dos2unix to convert file format "dos2unix merge_3-networks.sh", you may need to install dos2unix first
