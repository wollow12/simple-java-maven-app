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
    key            = "state2/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "github"
  }
}


resource "aws_instance" "NewMyServ" {
  ami                    = "ami-0914547665e6a707c"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.github-test.id]
  key_name               = "master_key"
  tags = {
    Name = "gitlab_testServ"
  }
user_data     =  "${file("script.sh")}"
}

resource "aws_security_group" "github-test" {
  name        = "github-test"
  description = "Allow SSH to web server"
  vpc_id      = data.aws_vpc.default.id
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  description       = "SSH ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.github-test.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  description       = "allow all"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.github-test.id
}


