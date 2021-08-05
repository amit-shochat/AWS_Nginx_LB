# --------------Provider -------------------------------

provider "aws" {
  profile = "default"
  region = var.aws_region
}


# --------------Local's -------------------------------
locals {
  ami = "ami-00f8e2c955f7ffa9b"
  instance_type = "t2.micro"
  ssh_key_name = "klika"
  ###tags_name##
  vpc_name="web-nginx-vpc"
  gateway_name= "web-nginx-gateway"
  internet_access_name = "web-nginx-internet_access"
  subnet_instances_name = "web-nginx-subnet-instances"
  }

# --------------Network's -------------------------------
# Create a VPC to launch our instances into
resource "aws_vpc" "web_nginx" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = local.vpc_name
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "web_nginx" {
  vpc_id = aws_vpc.web_nginx.id
  tags = {
    Name = local.gateway_name
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "web_nginx_internet_access" {
  route_table_id         = aws_vpc.web_nginx.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_nginx.id

}

# Create a subnet to launch our instances into
resource "aws_subnet" "web_nginx" {
  vpc_id                  = aws_vpc.web_nginx.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = local.subnet_instances_name
  }
}

# --------------Security group's -------------------------------

# --------------Security group ELB -------------------------------
resource "aws_security_group" "elb_web_nginx" {
  name        = "web_nginx_elb_terraform"
  description = "Web server create terraform"
  vpc_id      = aws_vpc.web_nginx.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --------------Security group user -------------------------------

# Our default security group to access
resource "aws_security_group" "user_web_nginx" {
  name        = "web_nginx_user_terraform"
  description = "Web server create terraform"
  vpc_id      = aws_vpc.web_nginx.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------ELB --------------------------

resource "aws_elb" "web-nginx" {
  name = "AWS-ELB-web-server"

  subnets         = [aws_subnet.web_nginx.id]
  security_groups = [aws_security_group.elb_web_nginx.id]
  instances       = aws_instance.web-nginx.*.id


  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }
  depends_on = [aws_instance.web-nginx]

}
# --------------- Instance Configuration ---------------

resource "aws_instance" "web-nginx" {
  count = var.instance_count
  instance_type = local.instance_type
  ami = local.ami
  key_name = local.ssh_key_name
  vpc_security_group_ids = [aws_security_group.user_web_nginx.id]
  subnet_id = aws_subnet.web_nginx.id
  user_data                   = file("./web_server_1.sh")
  tags = {
    Name = "web-ngnix-${count.index + 1}"
  }
}
