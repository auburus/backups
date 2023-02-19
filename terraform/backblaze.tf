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
