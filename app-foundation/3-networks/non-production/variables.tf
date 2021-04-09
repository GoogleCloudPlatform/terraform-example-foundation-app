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
  description = "Priority level for Cloud Armor policy. Lower numbers have higher priority."
  type        = number
}

variable "policy_expression" {
  description = "Textual representation of an expression in Common Expression Language syntax."
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
  description = "The name of the external IP address."
  type        = string
}

variable "address_type" {
  description = "Determines if the IP address will be internal or external. Only 'INTERNAL' or 'EXTERNAL' can be used."
  type        = string
  default     = "EXTERNAL"
}

variable "description" {
  description = "Describes what the external IP address will be used for."
  type        = string
  default     = "External IP for HTTP load balancing."
}
