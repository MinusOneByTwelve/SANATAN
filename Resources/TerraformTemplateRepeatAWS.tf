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

data "aws_subnet" "THE1VAL2HASH_ssubnet" {
  tags = {
    Name = "THE1VAL2HASH_subnet"
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

data "aws_security_group" "THE1VAL1HASH_ssg" {
  name = "THE1VAL1HASH_sg"
}

data "aws_s3_bucket" "THEREQUIREDINSTANCETHE1VAL1HASH_egb" {
  bucket = "awsTHEGLOBALBUCKET"
}

resource "aws_s3_bucket" "THEREQUIREDINSTANCEs3b" {
  bucket = "THEREQUIREDBUCKET"

  tags = {
    Name = "THEREQUIREDBUCKET"
  }
     
  lifecycle {
    prevent_destroy = false
  }  
}

resource "aws_s3_object" "THEREQUIREDINSTANCEs3bdo" {
  bucket = aws_s3_bucket.THEREQUIREDINSTANCEs3b.bucket
  key    = "THEREQUIREDBUCKET"
  content = "THEREQUIREDBUCKET"

  lifecycle {
    prevent_destroy = false
  }
}

data "aws_iam_policy_document" "THE1VAL1HASHs3dpTHEREQUIREDINSTANCE" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${data.aws_s3_bucket.THEREQUIREDINSTANCETHE1VAL1HASH_egb.bucket}",
      "arn:aws:s3:::${data.aws_s3_bucket.THEREQUIREDINSTANCETHE1VAL1HASH_egb.bucket}/*"
    ]    
  }
}

data "aws_iam_policy_document" "THEREQUIREDINSTANCEs3dp" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::THEREQUIREDBUCKET",
      "arn:aws:s3:::THEREQUIREDBUCKET/*"
    ]    
  }
}

resource "aws_iam_policy" "THE1VAL1HASHs3pTHEREQUIREDINSTANCE" {
  name   = "THE1VAL1HASHs3pTHEREQUIREDINSTANCE"
  policy = data.aws_iam_policy_document.THE1VAL1HASHs3dpTHEREQUIREDINSTANCE.json
}

resource "aws_iam_policy" "THEREQUIREDINSTANCEs3p" {
  name   = "THEREQUIREDINSTANCEs3p"
  policy = data.aws_iam_policy_document.THEREQUIREDINSTANCEs3dp.json
}

resource "aws_iam_role" "THEREQUIREDINSTANCEiamr" {
  name = "THEREQUIREDINSTANCEiamr"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "THEREQUIREDINSTANCEiamr_AmazonEC2FullAccess" {
  role       = aws_iam_role.THEREQUIREDINSTANCEiamr.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "THEREQUIREDINSTANCEiamr_THE1VAL1HASHs3p" {
  role       = aws_iam_role.THEREQUIREDINSTANCEiamr.name
  policy_arn = aws_iam_policy.THE1VAL1HASHs3pTHEREQUIREDINSTANCE.arn
}

resource "aws_iam_role_policy_attachment" "THEREQUIREDINSTANCEiamr_THEREQUIREDINSTANCEs3p" {
  role       = aws_iam_role.THEREQUIREDINSTANCEiamr.name
  policy_arn = aws_iam_policy.THEREQUIREDINSTANCEs3p.arn
}

resource "aws_iam_instance_profile" "THEREQUIREDINSTANCEiamip" {
  name = "THEREQUIREDINSTANCEiamip"
  role = aws_iam_role.THEREQUIREDINSTANCEiamr.name
}

data "aws_efs_file_system" "THE1VAL1HASH_efs" {
  tags = {
    Name = "THE1VAL1HASH_efs"
  }
}

data "template_file" "init_script" {
  template = file("THEPATHFOREFSTEMPLATE/template.sh.tpl")

  vars = {
    efs_dns_name = data.aws_efs_file_system.THE1VAL1HASH_efs.dns_name
  }
}

resource "aws_instance" "THEREQUIREDINSTANCE" {
  count                       = var.num_instances
  ami                         = "THEREQUIREDAMI"
  instance_type               = "THEREQUIREDTYPE"
  subnet_id                   = data.aws_subnet.THE1VAL2HASH_ssubnet.id
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [data.aws_security_group.THE1VAL1HASH_ssg.id]
  associate_public_ip_address = true
  availability_zone           = var.availability_zone  

  iam_instance_profile = aws_iam_instance_profile.THEREQUIREDINSTANCEiamip.name

  tags = {
    Name     = "THEREQUIREDINSTANCE-${count.index + 1}"
    Hostname = "THEREQUIREDINSTANCE-${count.index + 1}"
  }
  
  root_block_device {
    volume_size = THEDISKSIZE
    volume_type = "gp3"
    delete_on_termination = true
  } 
  
  user_data = data.template_file.init_script.rendered 
}

output "public_ips" {
  value = aws_instance.THEREQUIREDINSTANCE.*.public_ip
}

output "instance_names" {
  value = aws_instance.THEREQUIREDINSTANCE.*.tags.Name
}

