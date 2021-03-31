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

variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "location" {
  description = "Location for the keyring."
  type        = string
  default     = "us"
}

variable "keyring" {
  description = "Keyring name."
  type        = string
}

variable "keys" {
  description = "Key names."
  type        = list(string)
  default     = []
}

variable "owners" {
  description = "Owners for keys declared in set_owners."
  type        = list(string)
  default     = []
}

variable "prevent_destroy" {
  description = "set the prevent_destroy lifecycle."
  type        = string
  default     = "true"
}

variable "key_protection_level" {
  description = "set the protection level."
  type        = string
  default     = "HSM"
}
