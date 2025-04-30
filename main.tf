terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}



resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainIGW"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    Name = "PublicSubnet"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.public.id
}


resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Apache_web_Server" {
  ami           = "ami-00a929b66ed6e0de6"
  instance_type = "t2.micro"
  user_data = file("userdata.sh")
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  
  tags = {
    Name = "ApacheWebServer"
  }

}

  
