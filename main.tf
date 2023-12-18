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
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# AWS Security Group
resource "aws_security_group" "security_group_pub" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Practice Security Group"
  }
}

# AWS EC2 Instance for Public Subnet

resource "aws_instance" "public_instance" {
  ami                         = "ami-079db87dc4c10ac91"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.security_group_pub.id]
  associate_public_ip_address = true
  tags = {
    Name = "Public EC2 Instance"
  }

}