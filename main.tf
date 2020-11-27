#DEFINE PROVIDER
provider "aws" {
  access_key = "AKIA5SLNT3JVAV2GS7AA"
  secret_key = "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"
  region     = "us-east-2"
}
#DEFINE VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Hello vpc"
  }
}
#DEFINE PUBLIC SUBNET
resource "aws_subnet" "sn" {
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-2a"
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "Hello subnet"
  }
}
#DEFINE SECURITY GROUP
resource "aws_security_group" "abc" {
  name        = "sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
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

  tags = {
    Name = "Hello sg"
  }
}
#DEFINE INTERNET GATE WAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Hello-igw"
  }
}
# DEFINE THE ROUTE TABLE
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id  
 }
 tags = {
   Name = "Hello-rt"
   }
}
#ROUTE TABLE ASSOSIATION
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.sn.id
  route_table_id = aws_route_table.rt.id
}
#LAUNCH EC2 INSTANCE
resource "aws_instance" "server" {
  ami           = "ami-0dd9f0e7df0f0a138"
  instance_type = "t2.micro"
  key_name = "jyo"
  tags = {
    Name = "Hello Good morning"
  }
}
#DEFINE NETWORK INTERFACE
resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.sn.id
  private_ips     = ["10.1.1.100"]
  security_groups = [aws_security_group.abc.id]

  attachment {
    instance     = aws_instance.server.id
    device_index = 1
  }
}
#DEFINE KEY PAIR
# resource "aws_key_pair" "key" {
#   key_name   = "deployer-key"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
# }
    
