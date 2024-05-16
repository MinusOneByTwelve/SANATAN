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

data "aws_vpcs" "THE1VAL1HASH_svpc" {
  tags = {
    Name = "THE1VAL1HASH_vpc"
  }
}

variable "availability_zone" {
  description = "Desired Availability Zone for the subnet"
  type        = string
  THESUBREGIONSUBSTITUTE
}

data "aws_subnet" "THE1VAL1HASH_ssubnet" {
  tags = {
    Name = "THE1VAL1HASH_subnet"
  }
}

data "aws_internet_gateway" "THE1VAL1HASH_sigy" {
  tags = {
    Name = "THE1VAL1HASH_igy"
  }
}

data "aws_route_table" "THE1VAL1HASH_srt" {
  tags = {
    Name = "THE1VAL1HASH_rt"
  }
}

resource "aws_route_table_association" "THE1VAL1HASH_rta" {
  subnet_id = data.aws_subnet.THE1VAL1HASH_ssubnet.id
  route_table_id = data.aws_route_table.THE1VAL1HASH_srt.id
}

data "aws_security_group" "THE1VAL1HASH_ssg" {
  name = "THE1VAL1HASH_sg"
}

resource "aws_instance" "THEREQUIREDINSTANCE" {
  count                       = var.num_instances
  ami                         = "THEREQUIREDAMI"
  instance_type               = "THEREQUIREDTYPE"
  subnet_id                   = data.aws_subnet.THE1VAL1HASH_ssubnet.id
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [data.aws_security_group.THE1VAL1HASH_ssg.id]
  associate_public_ip_address = true
  availability_zone           = var.availability_zone  

  tags = {
    Name     = "THEREQUIREDINSTANCE-${count.index + 1}"
    Hostname = "THEREQUIREDINSTANCE-${count.index + 1}"
  }
}

output "public_ips" {
  value = aws_instance.THEREQUIREDINSTANCE.*.public_ip
}

output "instance_names" {
  value = aws_instance.THEREQUIREDINSTANCE.*.tags.Name
}

