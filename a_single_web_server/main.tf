provider "aws" {
  region = "eu-central-1"
}

variable "http_port" {
  description = "http port"
  default = 8080
}

resource "aws_instance" "example" {
  ami           = "ami-de8fb135"
  instance_type = "t2.micro"
  key_name      = "andre"
  vpc_security_group_ids = ["${aws_security_group.instance-sg.id}"]
  tags {
    Name = "terraform-example"
  }
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World!" > index.html
              nohup busybox httpd -f -p "${var.http_port}" &
              EOF
}

resource "aws_security_group" "instance-sg" {
  name = "example-instance-sg"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "${var.http_port}"
    to_port   = "${var.http_port}"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}
