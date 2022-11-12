terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "ap-northeast-2"
}

resource "aws_key_pair" "key_pair" {
  key_name = "teamo2_den_study"
  public_key = file("~/desktop/den/key/teamo2_den_study.pub")
}

resource "aws_security_group" "ssh" {
  name = "allow_ssh_from_all"
  description = "Allow SSH port from all"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3001
    to_port = 3001
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3002
    to_port = 3002
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_security_group" "default" {
  name = "default"
}

resource "aws_instance" "ec2" {
  ami = "ami-0e9bfdb247cc8de84"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    data.aws_security_group.default.id
  ]
  tags = {
    Name = "den msa study"
  }
}