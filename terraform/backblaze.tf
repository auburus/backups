terraform {
  required_providers {
    b2 = {
      source = "Backblaze/b2"
    }
  }
}

resource "random_string" "bucket_suffix" {
  length  = 63 - length("backups-")
  lower   = true
  upper   = false
  numeric = true
  special = false
}

resource "b2_bucket" "backups" {
  # Name needs to be globally unique, including other users
  bucket_name = "backups-${random_string.bucket_suffix.result}"
  bucket_type = "allPrivate"
}

resource "b2_application_key" "backups_write_access" {
  key_name = "backups-key"
  capabilities = [
    "listBuckets",
    "listFiles",
    "readFiles",
    "writeFiles",
    "deleteFiles",
    "readFileRetentions"
  ]

  # Restrict key to only affecting this bucket
  bucket_id = b2_bucket.backups.id

}

output "b2_backups_api_keys" {
  sensitive = true
  value = {
    "application_key"    = b2_application_key.backups_write_access.application_key
    "application_key_id" = b2_application_key.backups_write_access.application_key_id
  }
}

output "bucket_name" {
  value = b2_bucket.backups.bucket_name
}

