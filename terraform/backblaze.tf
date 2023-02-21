terraform {
  required_providers {
    b2 = {
      source = "Backblaze/b2"
    }
  }
}

variable "b2_bucket_name" {
  type = string
}

resource "b2_bucket" "borgbackups" {
  # Name needs to be globally unique, including other users
  bucket_name = var.b2_bucket_name
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
  bucket_id = b2_bucket.borgbackups.id

}

output "b2_backups_api_keys" {
  sensitive = true
  value = {
    "application_key"    = b2_application_key.backups_write_access.application_key
    "application_key_id" = b2_application_key.backups_write_access.application_key_id
  }
}

