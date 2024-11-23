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
