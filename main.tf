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

# Adding security to the stack
assume_role_with_web_identity {
    role_arn           = var.role_arn
    web_identity_token = var.identity_token
}

# Specifying instance parameters
resource "aws_instance" "app_server" {
  ami           = "ami-054a53dca63de757b"
  instance_type = "t2.micro"

# Adding instance tags
  tags = {
    Name = "EC2 Instance"
  }
}
