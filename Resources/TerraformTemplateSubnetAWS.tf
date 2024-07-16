provider "aws" {
  region     = "THEREQUIREDREGION"
  access_key = "THEREQUIREDACCESSKEY"
  secret_key = "THEREQUIREDSECRETKEY"
}

data "aws_vpcs" "THE1VAL1HASH_svpc" {
  tags = {
    Name = "THE1VAL1HASH_vpc"
  }
}

locals {
  THE1VAL1HASH_mvpc = try(element(data.aws_vpcs.THE1VAL1HASH_svpc.ids, 0), null)
}

variable "availability_zone" {
  description = "Desired Availability Zone for the subnet"
  type        = string
  THESUBREGIONSUBSTITUTE
}

resource "aws_subnet" "THE1VAL2HASH_subnet" {
  vpc_id     = local.THE1VAL1HASH_mvpc
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zone 
  tags = {
    Name = "THE1VAL2HASH_subnet"
  }   
}

data "aws_route_table" "THE1VAL1HASH_srt" {
  tags = {
    Name = "THE1VAL1HASH_rt"
  }
}

resource "aws_route_table_association" "THE1VAL2HASH_rta" {
  subnet_id      = aws_subnet.THE1VAL2HASH_subnet.id
  route_table_id = data.aws_route_table.THE1VAL1HASH_srt.id
}

data "aws_security_group" "THE1VAL1HASH_ssg" {
  name = "THE1VAL1HASH_sg"
}

data "aws_efs_file_system" "THE1VAL1HASH_efs" {
  tags = {
    Name = "THE1VAL1HASH_efs"
  }
}

resource "aws_efs_mount_target" "THE1VAL1HASH_emt" {
  file_system_id  = data.aws_efs_file_system.THE1VAL1HASH_efs.id
  subnet_id       = aws_subnet.THE1VAL2HASH_subnet.id
  security_groups = [data.aws_security_group.THE1VAL1HASH_ssg.id]
}

