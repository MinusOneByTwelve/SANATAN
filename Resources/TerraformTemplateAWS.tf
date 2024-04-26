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

resource "null_resource" "save_key_pair"  {
provisioner "local-exec" {
command = "echo '${local.pemkey}' > THEREQUIREDLOCPEMKEY/THEREQUIREDPEMKEY.pem"
  }
}

variable "num_instances" {
  description = "Number of instances"
  type        = number
  default     = THEREQUIREDINSTNUM
}

resource "aws_instance" "THEREQUIREDINSTANCE" {
  count                       = var.num_instances
  ami                         = "THEREQUIREDAMI"
  instance_type               = "THEREQUIREDTYPE"
  subnet_id                   = "THEREQUIREDSUBNET"
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = ["THEREQUIREDSECGRP"]
  associate_public_ip_address = true

  tags       = {
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

