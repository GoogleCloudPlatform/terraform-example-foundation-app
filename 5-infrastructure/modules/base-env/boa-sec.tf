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

locals {
  kms_locations = {
    gke_1 = var.location_primary,
    gke_2 = var.location_secondary,
    sql_1 = var.location_primary,
    sql_2 = var.location_secondary
  }
}

module "sink_sec" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 6.0"
  destination_uri        = module.log_destination.destination_uri
  filter                 = "resource.type:(cloudkms_keyring OR service_account OR global OR audited_resource OR project)"
  log_sink_name          = "sink-boa-${local.envs[var.env].short}-sec-to-ops"
  parent_resource_id     = var.boa_sec_project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

resource "random_string" "keyring_suffix" {
  length  = 4
  upper   = false
  number  = true
  lower   = true
  special = false
}

module "kms_keyrings_keys" {
  source   = "terraform-google-modules/kms/google"
  version  = "~> 2.0"
  for_each = local.kms_locations

  project_id           = var.boa_sec_project_id
  prevent_destroy      = false
  key_protection_level = "HSM"
  owners               = ["serviceAccount:${var.terraform_service_account}"]
  encrypters           = ["serviceAccount:${var.terraform_service_account}"]
  decrypters           = ["serviceAccount:${var.terraform_service_account}"]

  location           = each.value
  keyring            = "kms-ring-boa-${local.envs[var.env].short}-${each.value}-${each.key}-${random_string.bucket_name.result}"
  keys               = ["kms-key-h-boa-${local.envs[var.env].short}-${each.value}-${each.key}-${random_string.bucket_name.result}"]
  set_owners_for     = ["kms-key-h-boa-${local.envs[var.env].short}-${each.value}-${each.key}-${random_string.bucket_name.result}"]
  set_encrypters_for = ["kms-key-h-boa-${local.envs[var.env].short}-${each.value}-${each.key}-${random_string.bucket_name.result}"]
  set_decrypters_for = ["kms-key-h-boa-${local.envs[var.env].short}-${each.value}-${each.key}-${random_string.bucket_name.result}"]
}

resource "google_secret_manager_secret" "admin_password" {
  project   = var.boa_sec_project_id
  secret_id = module.kms_keyrings_keys["sql_1"].keyring_name
  labels = {
    label = module.kms_keyrings_keys["sql_1"].keyring_name
  }
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "keyring-secret-version" {
  secret      = google_secret_manager_secret.admin_password.id
  secret_data = var.sql_admin_password
}
