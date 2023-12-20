provider "aws" {
    region = "eu-north-1"
}

variable "cidr_blocks" {
    description = "cidr block and name tags for vpc and subnet"
    type = list(object({
        cidr_block = string
        name = string
    }))
}

variable "avail_zone" {
    default = "eu-north-1a"
}

resource "aws_vpc" "dev-vpc" {
    cidr_block = var.cidr_blocks[0].cidr_block
    tags = {
      Name: var.cidr_blocks[0].name
    }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = var.avail_zone
    tags = {
      Name: var.cidr_blocks[1].name
    }
}

data "aws_vpc" "existing_vpc" {
    default = true
}

output "dev-vpc-id" {
    value = aws_vpc.dev-vpc.id
}

output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-1.id
}