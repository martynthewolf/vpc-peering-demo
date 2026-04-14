terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}

provider "aws" {
  profile = "martynthewolf"
  region = "eu-west-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "martynthewolf_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "martynthewolf_sg" {
  vpc_id   = aws_vpc.main.id

  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = [
      "10.1.0.0/16",
      "144.124.161.166/32"
    ]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["144.124.161.166/32"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
}
resource "aws_route" "product_internet" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_key_pair" "product_key" {
  key_name   = "product-test-key"
  public_key = file("~/.ssh/product_test_key.pub")
}

resource "aws_instance" "product_test" {
  ami           = "ami-0d1b55a6d77a0c326"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.martynthewolf_subnet.id
  vpc_security_group_ids = [aws_security_group.martynthewolf_sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.product_key.key_name
}

resource "aws_iam_role" "ssm_role" {
  name = "product_test_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}