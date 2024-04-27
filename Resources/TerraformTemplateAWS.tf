provider "aws" {
  region     = "THEREQUIREDREGION"
  access_key = "THEREQUIREDACCESSKEY"
  secret_key = "THEREQUIREDSECRETKEY"
}

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "deployer" {
  key_name   = "THEREQUIREDPEMKEY"
  public_key = tls_private_key.my_key.public_key_openssh
}

locals {
  pemkey = nonsensitive(tls_private_key.my_key.private_key_pem)
}

resource "null_resource" "save_key_pair" {
  provisioner "local-exec" {
    command = "echo '${local.pemkey}' > THEREQUIREDLOCPEMKEY/THEREQUIREDPEMKEY.pem"
  }
}

variable "num_instances" {
  description = "Number of instances"
  type        = number
  default     = THEREQUIREDINSTNUM
}

resource "aws_vpc" "THEREQUIREDINSTANCE_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "THEREQUIREDINSTANCE_vpc"
  }   
}

variable "availability_zone" {
  description = "Desired Availability Zone for the subnet"
  type        = string
  THESUBREGIONSUBSTITUTE
}

resource "aws_subnet" "THEREQUIREDINSTANCE_subnet" {
  vpc_id     = aws_vpc.THEREQUIREDINSTANCE_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zone 
  tags = {
    Name = "THEREQUIREDINSTANCE_subnet"
  }   
}

resource "aws_internet_gateway" "THEREQUIREDINSTANCE_igy" {
  vpc_id = aws_vpc.THEREQUIREDINSTANCE_vpc.id
  tags = {
    Name = "THEREQUIREDINSTANCE_igy"
  }  
}

resource "aws_route_table" "THEREQUIREDINSTANCE_rt" {
  vpc_id = aws_vpc.THEREQUIREDINSTANCE_vpc.id
  tags = {
    Name = "THEREQUIREDINSTANCE_rt"
  }    
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.THEREQUIREDINSTANCE_igy.id
  }
}

resource "aws_route_table_association" "THEREQUIREDINSTANCE_rta" {
  subnet_id      = aws_subnet.THEREQUIREDINSTANCE_subnet.id
  route_table_id = aws_route_table.THEREQUIREDINSTANCE_rt.id
}

resource "aws_security_group" "THEREQUIREDINSTANCE_sg" {
  vpc_id      = aws_vpc.THEREQUIREDINSTANCE_vpc.id
  name        = "THEREQUIREDINSTANCE_sg"
  description = "Security group for SSH, HTTP, HTTPS, ICMP, and custom range"
THEAWSFIREWALLSETTINGS
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "THEREQUIREDINSTANCE" {
  count                       = var.num_instances
  ami                         = "THEREQUIREDAMI"
  instance_type               = "THEREQUIREDTYPE"
  subnet_id                   = aws_subnet.THEREQUIREDINSTANCE_subnet.id
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.THEREQUIREDINSTANCE_sg.id]
  associate_public_ip_address = true
  availability_zone           = var.availability_zone  

  tags = {
    Name     = "THEREQUIREDINSTANCE-${count.index + 1}"
    Hostname = "THEREQUIREDINSTANCE-${count.index + 1}"
  }
  
  provisioner "remote-exec" {
    inline = [
      "if command -v apt-get &> /dev/null; then",
      "  sudo useradd -m -s /bin/bash THEREQUIREDUSER",
      "  sudo usermod -aG sudo THEREQUIREDUSER",
      "  sudo su -c 'echo \"THEREQUIREDUSER ALL=(ALL) NOPASSWD: ALL\" | sudo tee /etc/sudoers.d/THEREQUIREDUSER'",
      "elif command -v yum &> /dev/null; then",
      "  sudo useradd -m -s /bin/bash THEREQUIREDUSER",
      "  sudo usermod -aG wheel THEREQUIREDUSER",
      "  sudo su -c 'echo \"THEREQUIREDUSER ALL=(ALL) NOPASSWD: ALL\" | sudo tee /etc/sudoers.d/THEREQUIREDUSER'",
      "fi",
      "sudo mkdir -p /home/THEREQUIREDUSER/.ssh",
      "sudo chmod 700 /home/THEREQUIREDUSER/.ssh",
      "sudo su -c 'echo \"${tls_private_key.my_key.public_key_openssh}\" | sudo tee /home/THEREQUIREDUSER/.ssh/authorized_keys'",
      "sudo chmod 600 /home/THEREQUIREDUSER/.ssh/authorized_keys",
      "sudo chown -R THEREQUIREDUSER:THEREQUIREDUSER /home/THEREQUIREDUSER/.ssh"
    ]
    connection {
      type        = "ssh"
      user        = "THEBASEOSUSER"
      private_key = tls_private_key.my_key.private_key_pem
      host        = self.public_ip
    }
  }
}

output "public_ips" {
  value = aws_instance.THEREQUIREDINSTANCE.*.public_ip
}

output "instance_names" {
  value = aws_instance.THEREQUIREDINSTANCE.*.tags.Name
}

