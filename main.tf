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
    key            = "state1/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "tf-test"
  }
}


resource "aws_instance" "NewMyServ" {
  ami                    = "ami-0914547665e6a707c"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_server_sg_tf.id]
  key_name               = "master_key"
  tags = {
    Name = "gitlab_testServ"
  }
user_data     =  "${file("script.sh")}"
}

data "aws_vpc" "default" {
  default = true
}
