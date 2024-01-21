provider "aws" {
    region = "eu-north-1"
}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_blocks
    tags = {
      Name: "${var.env_prefix}-vpc"
    }
}

module "myapp-subnet" {
    source = "./subnet"
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp-vpc.id
    route_table_id = aws_vpc.myapp-vpc.route_table_id
}

module "myapp-server" {
    source = "./webserver"
    vpc_id = aws_vpc.myapp-vpc.id
    my_ip = var.my_ip
    env_prefix = var.env_prefix
    public_key_location = var.public_key_location
    instance_type = var.instance_type
    subnet_id = module.myapp-subnet.subnet.id
    avail_zone = var.avail_zone
}
