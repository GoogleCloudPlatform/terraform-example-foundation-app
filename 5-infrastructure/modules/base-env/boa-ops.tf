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

module "sink_ops" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 6.0"
  destination_uri        = module.log_destination.destination_uri
  filter                 = ""
  log_sink_name          = "sink-boa-${local.envs[var.env].short}-ops"
  parent_resource_id     = var.boa_ops_project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

resource "random_string" "bucket_name" {
  length  = 4
  upper   = false
  number  = true
  lower   = true
  special = false
}

module "log_destination" {
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  version                  = "~> 6.0"
  project_id               = var.boa_ops_project_id
  storage_bucket_name      = "log-ops-${lower(var.location_secondary)}-01-${random_string.bucket_name.result}"
  location                 = var.location_secondary
  log_sink_writer_identity = module.sink_ops.writer_identity
  force_destroy            = true
}

resource "google_storage_bucket_iam_member" "gke_storage_sink_member" {
  bucket = module.log_destination.resource_name
  role   = "roles/storage.objectCreator"
  member = module.sink_gke.writer_identity
}

resource "google_storage_bucket_iam_member" "sql_storage_sink_member" {
  bucket = module.log_destination.resource_name
  role   = "roles/storage.objectCreator"
  member = module.sink_sql.writer_identity
}

resource "google_storage_bucket_iam_member" "sec_storage_sink_member" {
  bucket = module.log_destination.resource_name
  role   = "roles/storage.objectCreator"
  member = module.sink_sec.writer_identity
}
