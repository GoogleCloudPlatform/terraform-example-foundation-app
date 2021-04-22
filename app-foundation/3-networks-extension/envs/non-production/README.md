# 3-networks/non-production

This is an additional Terraform configuration for [example_foundation 3-Networks/envs/non-production](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/3-networks/envs/non-production) and can be used to set up the subnets, additional firewall rules, and private service networking for the Bank of Anthos example application in the non-production environment.

## Prerequisites

1. 0-bootstrap executed successfully.
1. 1-org executed successfully.
1. 2-environments/envs/development executed successfully.

## Resources added

This module adds:
1. 4 Subnets - 1 Subnet for each cluster (gke1-cluster, gke2-cluster, mci-cluster) and one bastion-host-subnet to the default Base Shared VPC configuration from 3-networks
1. 4 Ingress and 3 Egress Firewall Rules
