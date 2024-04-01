terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41.0"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "staticwebbucket.com"
    key            = "state/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "tf-test"
  }
}

variable "ec2_tag" {
  type        = string
  description = "(optional) ec2 tag/name"
}


resource "aws_instance" "NewMyServ" {
  ami                    = "ami-0914547665e6a707c"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_server_sg_tf.id]
  key_name               = "master_key"
  tags = {
    Name = "${var.ec2_tag}"
  }
user_data     =  "${file("script.sh")}"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web_server_sg_tf" {
  name        = "web-server-sg-tf"
  description = "Allow HTTP/S and SSH to web server"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  description       = "HTTPS ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server_sg_tf.id
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  description       = "HTTP ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server_sg_tf.id
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  description       = "SSH ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server_sg_tf.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  description       = "allow all"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server_sg_tf.id
}
