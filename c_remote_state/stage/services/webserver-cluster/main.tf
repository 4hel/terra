terraform {
  backend "s3" {
    bucket = "4hel-terraform-chapter-3"
    key    = "stage/services/webserver-cluster/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "all" {}

data "terraform_remote_state" "db" {
  backend = "s3"
  config {
    bucket = "4hel-terraform-chapter-3"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "template_file" "user_data" {
  template = "${file("user-data.sh")}"

  vars {
    server_port = "${var.http_port}"
    db_address  = "${data.terraform_remote_state.db.address}"
    db_port     = "${data.terraform_remote_state.db.port}"
  }
}

resource "aws_launch_configuration" "example" {
  image_id        = "ami-de8fb135"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.instance-sg.id}"]
  user_data = "${data.template_file.user_data.rendered}"
  lifecycle {
    create_before_destroy = true # transitive needed
  }
}

resource "aws_security_group" "instance-sg" {
  name = "http-asg-sg"

  ingress {
    from_port = "${var.http_port}"
    to_port   = "${var.http_port}"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true # transitive needed
  }
}

resource "aws_security_group" "elb-sg" {
  name = "elb-sg"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true # transitive needed
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  load_balancers    = ["${aws_elb.example.name}"]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_elb" "example" {
  name = "terraform-asg-example"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${aws_security_group.elb-sg.id}"]

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.http_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 15
    target              = "HTTP:${var.http_port}/"
  }
}
