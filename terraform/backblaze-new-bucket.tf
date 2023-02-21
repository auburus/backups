
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

output "bucket_name" {
  value = b2_bucket.backups.bucket_name
}

