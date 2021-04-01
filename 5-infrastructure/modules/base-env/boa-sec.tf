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

module "sink_sec" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 5.2"
  destination_uri        = module.log_destination.destination_uri
  filter                 = "resource.type:(cloudkms_keyring OR service_account OR global OR audited_resource OR project)"
  log_sink_name          = "sink-boa-sec-01"
  parent_resource_id     = var.boa_sec_project_id != "" ? var.boa_sec_project_id : local.auto_sec_project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

resource "google_service_account" "kms_service_account" {
  account_id   = "${var.project_prefix}-${var.business_unit}-${var.environment_code}-boa-sec-kms-sa"
  display_name = "KMS Secrets SA"
  project      = var.boa_sec_project_id != "" ? var.boa_sec_project_id : local.auto_sec_project_id
}

module "kms_gke_1" {
  source               = "terraform-google-modules/kms/google"
  version              = "~> 2.0"
  project_id           = var.boa_sec_project_id != "" ? var.boa_sec_project_id : local.auto_sec_project_id
  location             = var.location_primary != "" ? var.location_primary : var.kms_location_1
  keyring              = "kms-ring-boa-${var.location_primary != "" ? var.location_primary : var.kms_location_1}-gke-01"
  keys                 = ["kms-key-h-boa-${var.location_primary != "" ? var.location_primary : var.kms_location_1}-gke-01"]
  prevent_destroy      = false
  key_protection_level = "HSM"
  owners               = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  set_owners_for       = ["kms-key-h-boa-${var.location_primary != "" ? var.location_primary : var.kms_location_1}-gke-01"]
  encrypters           = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  set_encrypters_for   = ["kms-key-h-boa-${var.location_primary != "" ? var.location_primary : var.kms_location_1}-gke-01"]
  decrypters           = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  set_decrypters_for   = ["kms-key-h-boa-${var.location_primary != "" ? var.location_primary : var.kms_location_1}-gke-01"]
}

module "kms_gke_2" {
  source               = "terraform-google-modules/kms/google"
  version              = "~> 2.0"
  project_id           = var.boa_sec_project_id != "" ? var.boa_sec_project_id : local.auto_sec_project_id
  location             = var.location_secondary != "" ? var.location_secondary : var.kms_location_2
  keyring              = "kms-ring-boa-${var.location_secondary != "" ? var.location_secondary : var.kms_location_2}-gke-01"
  keys                 = ["kms-key-h-boa-${var.location_secondary != "" ? var.location_secondary : var.kms_location_2}-gke-01"]
  prevent_destroy      = false
  key_protection_level = "HSM"
  owners               = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  set_owners_for       = ["kms-key-h-boa-${var.location_secondary != "" ? var.location_secondary : var.kms_location_2}-gke-01"]
  encrypters           = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  set_encrypters_for   = ["kms-key-h-boa-${var.location_secondary != "" ? var.location_secondary : var.kms_location_2}-gke-01"]
  decrypters           = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  set_decrypters_for   = ["kms-key-h-boa-${var.location_secondary != "" ? var.location_secondary : var.kms_location_2}-gke-01"]
}

module "kms_sql_1" {
  source               = "terraform-google-modules/kms/google"
  version              = "~> 2.0"
  project_id           = var.boa_sec_project_id != "" ? var.boa_sec_project_id : local.auto_sec_project_id
  location             = var.location_primary != "" ? var.location_primary : var.kms_location_1
  keyring              = "kms-ring-boa-${var.location_primary != "" ? var.location_primary : var.kms_location_1}-sql-01"
  keys                 = ["kms-key-h-boa-${var.location_primary != "" ? var.location_primary : var.kms_location_1}-sql-01"]
  prevent_destroy      = false
  key_protection_level = "HSM"
  owners               = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  set_owners_for       = ["kms-key-h-boa-${var.location_primary != "" ? var.location_primary : var.kms_location_1}-sql-01"]
  encrypters           = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  set_encrypters_for   = ["kms-key-h-boa-${var.location_primary != "" ? var.location_primary : var.kms_location_1}-sql-01"]
  decrypters           = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  set_decrypters_for   = ["kms-key-h-boa-${var.location_primary != "" ? var.location_primary : var.kms_location_1}-sql-01"]
}

module "kms_sql_2" {
  source               = "terraform-google-modules/kms/google"
  version              = "~> 2.0"
  project_id           = var.boa_sec_project_id != "" ? var.boa_sec_project_id : local.auto_sec_project_id
  location             = var.location_secondary != "" ? var.location_secondary : var.kms_location_2
  keyring              = "kms-ring-boa-${var.location_secondary != "" ? var.location_secondary : var.kms_location_2}-sql-01"
  keys                 = ["kms-key-h-boa-${var.location_secondary != "" ? var.location_secondary : var.kms_location_2}-sql-01"]
  prevent_destroy      = false
  key_protection_level = "HSM"
  owners               = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  set_owners_for       = ["kms-key-h-boa-${var.location_secondary != "" ? var.location_secondary : var.kms_location_2}-sql-01"]
  encrypters           = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  set_encrypters_for   = ["kms-key-h-boa-${var.location_secondary != "" ? var.location_secondary : var.kms_location_2}-sql-01"]
  decrypters           = ["serviceAccount:${google_service_account.kms_service_account.email}"]
  set_decrypters_for   = ["kms-key-h-boa-${var.location_secondary != "" ? var.location_secondary : var.kms_location_2}-sql-01"]
}
