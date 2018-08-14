terraform {
  backend "s3" {
    bucket = "4hel-terraform-chapter-3"
    key    = "global/s3/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "4hel-terraform-chapter-3"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
