terraform {
  backend "s3" {
    bucket = "4hel-terraform-chapter-3"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_db_instance" "example" {
    engine              = "mysql"
    allocated_storage   = 10
    instance_class      = "db.t2.micro"
    name                = "example_database"
    username            = "admin"
    password            = "${var.db_password}"
    skip_final_snapshot = true
    # final_snapshot_identifier = "final-snapshot-${md5(timestamp())}"
}
