terraform {
  backend "s3" {
    bucket = "4hel-terraform-chapter-4"
    key    = "stage/services/webserver-cluster/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "webserver-cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "4hel-terraform-chapter-4"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
}
