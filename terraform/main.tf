# VPC
resource "aws_vpc" "dadjokes_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dadjokes-vpc"
  }
}

# Sous-réseau public
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.dadjokes_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-north-1"  
  tags = {
    Name = "dadjokes-public-subnet"
  }
}

# Gateway Internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dadjokes_vpc.id
  tags = {
    Name = "dadjokes-gw"
  }
}

# Table de routage
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.dadjokes_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "dadjokes-public-route-table"
  }
}

# Association table de routage - sous-réseau
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Groupe de sécurité
resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.dadjokes_vpc.id


  ingress = [
    for port in [22, 80]: {
        description = "Inbound traffic"
        from_port   = port
        to_port     = port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}

# Instance EC2
resource "aws_instance" "web_server" {
  ami                    = "ami-08935252a36e26f85"  
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
  key_name               = "x"  

  tags = {
    Name = "dadjokes-web-server"
  }
}

# Output - Adresse IP publique de l'instance
output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}
