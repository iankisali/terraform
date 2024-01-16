provider "aws" {
    region = "eu-north-1"
}

variable "vpc_cidr_blocks" {}
variable "subnet_cidr_blocks" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "public_key_location" {}
variable "private_key_location" {}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_blocks
    tags = {
      Name: "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_blocks
    availability_zone = var.avail_zone
    tags = {
      Name: "${var.env_prefix}-subnet-1"
    }
}

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id
    tags = {
        Name: "${var.env_prefix}-internetgateway"
    }
}

resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-routetable"
    }
}

/*Configuring default route table*/
/*resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-main-rtb"
    }
}*/

resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    /*Allowing exiting of all traffic from all ports, protocols and cidr blocks*/
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }
    tags = {
        Name: "${var.env_prefix}-sg"
    }
}

/*resource "aws_default_security_group" "default-sg" {
    name = "myapp-default-sg"
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }
    tags = {
        Name: "${var.env_prefix}-default-sg"
    }
}*/



/*data means that tf expects the existance*/
data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    /*defining criteria for querying*/
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-2.0.20231206.0-x86_64-gp2"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

}

resource "aws_instance" "myapp-server" {
    /*setting ami dynamically*/
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type

    /*optional arguments*/
    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]/*you can confure multipe sg*/
    availability_zone = var.avail_zone

    /*Assigning public ip ->access from browser*/
    associate_public_ip_address = true

    /*key_name = myapp-sg*/
    key_name = aws_key_pair.ssh-key.key_name


    /* gets executed once on initial run*/
    /*user_data = file("entry-script.sh")*/

    /*user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y && sudo yum install -y docker
                sudo systemctl start docker
                sudo usermod -aG docker ec2-user
                docker run -p 8080:80 nginx
                EOF*/


    connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = file(var.private_key_location)
    }

    provisioner "file" {
        source = "entry-script.sh"
        destination = "/home/ec2-user/entry-script-ec2.sh"
    }

    provisioner "remote-exec" {
        script = file("entry-script-ec2.sh")
    }

    provisioner "local-exec" {
        command = "echo${self.public_ip} > output.txt"
    }

    tags = {
      Name = "${var.env_prefix}-server"
    }

    
}

resource "aws_key_pair" "ssh-key" {
    key_name = "ec2-server-key-pair"

   /* public_key = "${file(var.public_key_location)}"*/
    public_key = file(var.public_key_location)
}


output "dev-vpc-id" {
    value = aws_vpc.myapp-vpc.id
}

output "dev-subnet-id" {
    value = aws_subnet.myapp-subnet-1.id
}

output "dev-igw-id" {
    value = aws_internet_gateway.myapp-igw.id
}

output "dev-route-table-id" {
    value = aws_route_table.myapp-route-table.id
}

output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
}

output "ec2-public-ip" {
  value = aws_instance.myapp-server.public_ip
}