provider "aws" {
  region     = "THEREQUIREDREGION"
  access_key = "THEREQUIREDACCESSKEY"
  secret_key = "THEREQUIREDSECRETKEY"
}

resource "aws_vpc" "THE1VAL1HASH_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "THE1VAL1HASH_vpc"
  }   
}

resource "aws_internet_gateway" "THE1VAL1HASH_igy" {
  vpc_id = aws_vpc.THE1VAL1HASH_vpc.id
  tags = {
    Name = "THE1VAL1HASH_igy"
  }  
}

resource "aws_route_table" "THE1VAL1HASH_rt" {
  vpc_id = aws_vpc.THE1VAL1HASH_vpc.id
  tags = {
    Name = "THE1VAL1HASH_rt"
  }    
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.THE1VAL1HASH_igy.id
  }
}

resource "aws_security_group" "THE1VAL1HASH_sg" {
  vpc_id      = aws_vpc.THE1VAL1HASH_vpc.id
  name        = "THE1VAL1HASH_sg"
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

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "50"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "THE1VAL1HASHs3b" {
  bucket = "awsTHEGLOBALBUCKET"

  tags = {
    Name = "awsTHEGLOBALBUCKET"
  }
     
  lifecycle {
    prevent_destroy = false
  }  
}

resource "aws_s3_object" "THE1VAL1HASHs3bdo" {
  bucket = aws_s3_bucket.THE1VAL1HASHs3b.bucket
  key    = "THE1VAL1HASH"
  content = "THE1VAL1HASH"

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_efs_file_system" "THE1VAL1HASH_efs" {
  creation_token = "THE1VAL1HASH_efs"

  tags = {
    Name = "THE1VAL1HASH_efs"
  }
}

