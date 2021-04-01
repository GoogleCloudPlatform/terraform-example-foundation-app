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

variable "admin_user" {
  #sensitive = true
  type        = string
  description = "The admin username"
}

variable "admin_password" {
  #sensitive = true
  type        = string
  description = "The admin password"
}

variable "sql_instance_prefix" {
  type        = string
  description = "The instance name prefix, random string is added as suffix"
}

variable "database_name" {
  type        = string
  description = "The database name"
}

variable "database_region" {
  type        = string
  description = "The database region"
}

variable "database_users" {
  type = list(object({
    name     = string
    password = string
    host     = string
  }))
  description = "Additional Database Users"
  default     = []
}

variable "database_zone" {
  type        = string
  description = "The database zone"
}

variable "project_id" {
  type        = string
  description = "The GCP Project ID"
}

variable "replica_zones" {
  type = object({
    zone1 = string
    zone2 = string
    zone3 = string
  })
  description = "The GCP Zones"
}

variable "vpc" {
  type        = string
  description = "The name of the VPC to be given private access"
}

variable "network_project_id" {
  type        = string
  description = "The Shared VPC Host Project ID"
}

variable "encrypt_keyring_name" {
  type        = string
  description = "KMS Keyring Name to create secret with same name to store admin password of sql instance"
}

variable "additional_databases" {
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  description = "Additional Databases"
  default     = []
}
