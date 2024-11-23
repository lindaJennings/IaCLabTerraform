# Specifying provider for stack
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Adding AWS region for the stack instance
provider "aws" {
  region  = "eu-west-1"
}

# Adding vpc with subnets and gateway
resource "vpc" "my_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-lab-vpc"
  cidr = "10.0.0.0/16"

  private_subnets = ["10.0.2.0/24"]
  public_subnets  = ["10.0.1.0/24"]

  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

# Adding a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "VPC public subnet"
  }
}

# Adding a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "VPC private subnet"
  }
}

# Attaching an internet gateway to the public subnet
resource "aws_internet_gateway" "public_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Public internet gateway"
  }
}

# Creating a route table and association for public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.public_gateway.id
  }

  tags = {
    Name = "Public route table"
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id

}

# Creating a route table and association for private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Private route table"
  }
}

resource "aws_route_table_association" "private_route_association" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id

}

# Specifying instance parameters
resource "aws_instance" "my_instance" {
  ami           = "ami-054a53dca63de757b"
  instance_type = "t2.micro"
  key_name = "myKeyPair"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = aws_security_group.instance_security.id

# Adding instance tags
  tags = {
    Name = "EC2 Instance"
  }
}
