terraform {
  backend "s3" {
    bucket = "4hel-terraform-chapter-4"
    key    = "prod/services/webserver-cluster/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "webserver-cluster" {
  source = "../../../modules/services/webserver-cluster"

  env                    = "prod"
  db_remote_state_bucket = "4hel-terraform-chapter-4"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"
}
