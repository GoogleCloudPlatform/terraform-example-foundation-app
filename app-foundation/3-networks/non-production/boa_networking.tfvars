/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******************************************
 Tfvars for BoA shared VPC
*****************************************/

default_region1 = "us-east1"

default_region2 = "us-west1"

nat_enabled = "true"

enable_hub_and_spoke = "true"

enable_hub_and_spoke_transitivity = "true"

/******************************************
 Tfvars for Cloud Armor
*****************************************/

policy_name = "cloud-armor-xss-policy"

policy_action = "deny(403)"

policy_priority = "1000"

policy_expression = "evaluatePreconfiguredExpr('xss-stable')"

policy_description = "Cloud Armor policy to prevent cross-site scripting attacks."

/******************************************
 Tfvars for private services address
*****************************************/

private_service_address_name = "cloud-sql-subnet-vpc-peering-internal"

/******************************************
 Tfvars for external IP
*****************************************/

address_name = "mci-ip"

address_type = "EXTERNAL"

description = "External IP address for HTTP load balancing on MCI subnet."
