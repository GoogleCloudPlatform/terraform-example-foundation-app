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
 Variables for BoA subnets
*****************************************/

variable "subnets" {
  description = "The list of subnets being created for the application."
  type        = list(map(string))
}

variable "secondary_ranges" {
  description = "Secondary ranges that will be used in some of the application's subnets."
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  default     = {}
}

/******************************************
 Variables for Cloud Armor
*****************************************/

variable "policy_name" {
  description = "Name of the Cloud Armor security policy."
  type        = string
}

variable "policy_action" {
  description = "Specify if you want to allow or deny traffic."
  type        = string
}

variable "policy_priority" {
  description = "Priority level for policy - lower numbers have higher priority."
  type        = string
}

variable "policy_expression" {
  description = "Expression used to configure what is intended to match the policy."
  type        = string
}

variable "policy_description" {
  description = "Description of the security policy."
  type        = string
}

/******************************************
 Variables for private services address
*****************************************/

variable "private_services_address_name" {
  description = "The name of the private services address."
  type        = string
  default     = null
}

/******************************************
 Variables for external IP
*****************************************/

variable "address_name" {
  description = "What the external IP address will be used for."
  type        = string
}

variable "address_type" {
  description = "Determines if the IP address will be internal or external."
  type        = string
}

variable "description" {
  description = "What the external IP address will be used for."
  type        = string
}
