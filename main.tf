terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Credentials 
provider "aws" {
  region     = "us-east-1"
  access_key = var.access_credentials.access_key
  secret_key = var.access_credentials.secret_key
}

# Block to create VPC
resource "aws_vpc" "name_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Practice VPC"
  }
}

# Block to create Public Subnet
resource "aws_subnet" "public_subnet" {
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.name_vpc.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "Public Subnet"
  }
}

# Block to create Private Subnet
resource "aws_subnet" "private_subnet" {
  availability_zone = "us-east-1b"
  vpc_id            = aws_vpc.name_vpc.id
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "Private Subnet"
  }
}