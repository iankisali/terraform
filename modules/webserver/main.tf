resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = var.vpc_id

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
    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]/*you can confure multipe sg*/
    availability_zone = var.avail_zone

    /*Assigning public ip ->access from browser*/
    associate_public_ip_address = true

    /*key_name = myapp-sg*/
    key_name = aws_key_pair.ssh-key.key_name


    /* gets executed once on initial run*/
    user_data = file("entry-script.sh")

    tags = {
      Name = "${var.env_prefix}-server"
    }

    
}

resource "aws_key_pair" "ssh-key" {
    key_name = "ec2-server-key-pair"

   /* public_key = "${file(var.public_key_location)}"*/
    public_key = file(var.public_key_location)
}