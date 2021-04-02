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
  kms_settings = {
    kms_gke_1 = {
      location           = var.location_primary
      keyring            = "kms-ring-boa-${var.location_primary}-gke-01"
      keys               = ["kms-key-h-boa-${var.location_primary}-gke-01"]
      set_owners_for     = ["kms-key-h-boa-${var.location_primary}-gke-01"]
      set_encrypters_for = ["kms-key-h-boa-${var.location_primary}-gke-01"]
      set_decrypters_for = ["kms-key-h-boa-${var.location_primary}-gke-01"]
    },
    kms_gke_2 = {
      location           = var.location_secondary
      keyring            = "kms-ring-boa-${var.location_secondary}-gke-01"
      keys               = ["kms-key-h-boa-${var.location_secondary}-gke-01"]
      set_owners_for     = ["kms-key-h-boa-${var.location_secondary}-gke-01"]
      set_encrypters_for = ["kms-key-h-boa-${var.location_secondary}-gke-01"]
      set_decrypters_for = ["kms-key-h-boa-${var.location_secondary}-gke-01"]
    },
    kms_sql_1 = {
      location           = var.location_primary
      keyring            = "kms-ring-boa-${var.location_primary}-sql-01"
      keys               = ["kms-key-h-boa-${var.location_primary}-sql-01"]
      set_owners_for     = ["kms-key-h-boa-${var.location_primary}-sql-01"]
      set_encrypters_for = ["kms-key-h-boa-${var.location_primary}-sql-01"]
      set_decrypters_for = ["kms-key-h-boa-${var.location_primary}-sql-01"]
    },
    kms_sql_2 = {
      location           = var.location_secondary
      keyring            = "kms-ring-boa-${var.location_secondary}-sql-01"
      keys               = ["kms-key-h-boa-${var.location_secondary}-sql-01"]
      set_owners_for     = ["kms-key-h-boa-${var.location_secondary}-sql-01"]
      set_encrypters_for = ["kms-key-h-boa-${var.location_secondary}-sql-01"]
      set_decrypters_for = ["kms-key-h-boa-${var.location_secondary}-sql-01"]
    }
  }
}

module "sink_sec" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 5.2"
  destination_uri        = module.log_destination.destination_uri
  filter                 = "resource.type:(cloudkms_keyring OR service_account OR global OR audited_resource OR project)"
  log_sink_name          = "sink-boa-sec-01"
  parent_resource_id     = var.boa_sec_project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

resource "google_service_account" "kms_service_account" {
  account_id   = "boa-${var.business_unit}-${local.envs[var.env].short}-sec-kms-sa"
  display_name = "KMS Secrets SA"
  project      = var.boa_sec_project_id
}

module "kms_keyrings_keys" {
  source   = "terraform-google-modules/kms/google"
  version  = "~> 2.0"
  for_each = local.kms_settings

  project_id           = var.boa_sec_project_id
  prevent_destroy      = false
  key_protection_level = "HSM"
  owners               = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  encrypters           = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  decrypters           = ["serviceAccount:${google_service_account.kms_service_account.email}"]

  location           = each.value.location
  keyring            = each.value.keyring
  keys               = each.value.keys
  set_owners_for     = each.value.set_owners_for
  set_encrypters_for = each.value.set_encrypters_for
  set_decrypters_for = each.value.set_decrypters_for
}
