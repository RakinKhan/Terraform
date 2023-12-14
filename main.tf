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
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Practice VPC"
  }
}

# Block to create Public Subnet
resource "aws_subnet" "public_subnet" {
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "Public Subnet"
  }
}

# Block to create Private Subnet
resource "aws_subnet" "private_subnet" {
  availability_zone = "us-east-1b"
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "Private Subnet"
  }
}

# Block got internet Gateway
resource "aws_internet_gateway" "public_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Public Internet Gateway"
  }
}

# Route Table (Public)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_gateway.id
  }
  tags = {
    Name = "Public RT"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public_rta" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}