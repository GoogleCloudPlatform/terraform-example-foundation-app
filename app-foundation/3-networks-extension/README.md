# 3-networks-extension

This is an additional Terraform configuration for [CFT 3-Networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks) and can be used to set up the subnets, additional firewall rules for the Bank of Anthos example application in the development environment.

## Prerequisites

1. 0-bootstrap executed successfully.
1. 1-org executed successfully.
1. 2-environments/envs/ executed successfully.

## Order of Execution

1. Run merge_3-networks.sh
1. 3-netowrks/envs/shared
1. 3-networks/envs/ development/non-production/production

## Steps performed in bash script

1. Clone [CFT 3-Networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks)
1. Merge files from 3-networks-extensions/envs into 3-networks/envs for the respective environments
1. Change Primary Region in [3-networks/common.auto.tfvars](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/common.auto.example.tfvars) from us-central1 to us-east1 to be consistent with BOA 4-projects and 5-infrastructure
1. Remove Base Shared VPC defined in main.tf of [CFT 3-Networks](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks) as boa_vpc.tf replaces it with new subnets.

## Local Run Troubleshooting

1. Ensure you have given execute permissions "chmod +x merge_3-networks.sh"
1. If you get '\r Error' you can use dos2unix to convert file format "dos2unix merge_3-networks.sh", you may need to install dos2unix first
