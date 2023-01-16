terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-south-1"
}

resource "aws_instance" "app_server" {
#  ami                        = "ami-0cca134ec43cf708f"      #ap-south-2 ami defied
  ami                         = "ami-0cca134ec43cf708f"      #ap-sout-1 ami defied
  instance_type               = "t2.micro"
  key_name = "test-key1"
  associate_public_ip_address = true 
# root disk
  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    delete_on_termination = true
  }
# data disk
  ebs_block_device {
    device_name           = "xvdf"
    volume_size           = "10"
    volume_type           = "gp2"
    delete_on_termination = true
  } 

  user_data = <<-EOF
                #! /bin/bash
                   yum install httpd -y
                   systemctl start httpd
                   systemctl enable httpd
  EOF

  tags = {
    Name         = "Server01"
    env          =  "terraform-test"
    terraform    = "true"
  }
}


# VPC
resource "aws_vpc" "test-vpc" {
  cidr_block                = "190.160.0.0/16"
  instance_tenancy          = "default"

}

# Subnets
resource "aws_subnet" "subnet1"  {
  vpc_id                    = "${aws_vpc.test-vpc.id}"
  cidr_block                =  "190.160.0.0/24"

}

resource "aws_internet_gateway" "gw" {
  vpc_id                    = "${aws_vpc.test-vpc.id}" 

}
 














