terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}

provider "aws" {
  profile = "veritytheotter"
  region = "eu-west-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "veritytheotter_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.1.0/24"
}

resource "aws_security_group" "veritytheotter_sg" {
  vpc_id   = aws_vpc.main.id

  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource aws_key_pair "veritytheotter_key" {
  key_name = "veritytheotter_key"
  public_key = file("~/.ssh/product_test_key.pub")
}

resource "aws_instance" "veritytheotter_test" {
  ami           = "ami-0d1b55a6d77a0c326"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.veritytheotter_subnet.id
  vpc_security_group_ids = [aws_security_group.veritytheotter_sg.id]
  key_name = aws_key_pair.veritytheotter_key.key_name
}