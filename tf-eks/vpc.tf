provider "aws" {
  region = "eu-north-1"
}

variable "vpc_cidr_block" {}
variable "private_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}

data "aws_availability_zones" "azs" {}


/*Module downloaded with terraform init*/
module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"


  name = "myapp-vpc"
  cidr = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks

    /*setting azs dynamically*/
  azs = data.aws_availability_zones.azs.names

  enable_nat_gateway = true

  /*private subnet route traffic internet traffic through this*/
  single_nat_gateway = true

  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}