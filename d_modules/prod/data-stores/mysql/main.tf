terraform {
  backend "s3" {
    bucket = "4hel-terraform-chapter-4"
    key    = "prod/data-stores/mysql/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "mysql" {
  source = "../../../modules/data-stores/mysql"

  env         = "prod"
  db_password = "${var.db_password}"
}
