terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}

provider "aws" {
  alias   = "martynthewolf"
  profile = "martynthewolf"
  region  = "eu-west-1"
}

provider "aws" {
  alias   = "veritytheotter"
  profile = "veritytheotter"
  region  = "eu-west-1"
}

# -----------------------------
# Fetch VPC info dynamically
# -----------------------------

data "aws_vpcs" "martynthewolf" {
  provider = aws.martynthewolf
}

data "aws_vpcs" "veritytheotter" {
  provider = aws.veritytheotter
}

data "aws_vpc" "martynthewolf" {
  provider = aws.martynthewolf
  id       = data.aws_vpcs.martynthewolf.ids[0]
}

data "aws_vpc" "veritytheotter" {
  provider = aws.veritytheotter
  id       = data.aws_vpcs.veritytheotter.ids[0]
}

# -----------------------------
# Main route tables
# -----------------------------

data "aws_route_tables" "martynthewolf_main" {
  provider = aws.martynthewolf
  vpc_id   = data.aws_vpc.martynthewolf.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

data "aws_route_tables" "veritytheotter_main" {
  provider = aws.veritytheotter
  vpc_id   = data.aws_vpc.veritytheotter.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

# -----------------------------
# Account IDs
# -----------------------------

data "aws_caller_identity" "martynthewolf" {
  provider = aws.martynthewolf
}

data "aws_caller_identity" "veritytheotter" {
  provider = aws.veritytheotter
}

# -----------------------------
# VPC peering
# -----------------------------

resource "aws_vpc_peering_connection" "peer" {
  provider      = aws.martynthewolf
  vpc_id        = data.aws_vpc.martynthewolf.id
  peer_vpc_id   = data.aws_vpc.veritytheotter.id
  peer_owner_id = data.aws_caller_identity.veritytheotter.account_id
}

resource "aws_vpc_peering_connection_accepter" "peer_accept" {
  provider                  = aws.veritytheotter
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true
}

# -----------------------------
# Routes
# -----------------------------

resource "aws_route" "martynthewolf_to_veritytheotter" {
  provider                  = aws.martynthewolf
  route_table_id            = data.aws_route_tables.martynthewolf_main.ids[0]
  destination_cidr_block    = data.aws_vpc.veritytheotter.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "veritytheotter_to_martynthewolf" {
  provider                  = aws.veritytheotter
  route_table_id            = data.aws_route_tables.veritytheotter_main.ids[0]
  destination_cidr_block    = data.aws_vpc.martynthewolf.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
