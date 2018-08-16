resource "aws_db_instance" "example" {
    engine              = "mysql"
    allocated_storage   = 10
    instance_class      = "db.t2.micro"
    name                = "${var.env}"
    identifier          = "${var.env}-terraform"
    username            = "admin"
    password            = "${var.db_password}"
    skip_final_snapshot = true
    # final_snapshot_identifier = "final-snapshot-${md5(timestamp())}"
}
