terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
    random = {
      source  = "hashicorp/random"
    }
  }
}

provider "google" {
  credentials = file("GCPSCOPE1VAL")
  project     = "GCPSCOPE2VAL"
  region      = var.region
}

provider "random" {
  
}

data "google_compute_zones" "THEREQUIREDINSTANCEgcz" {
  region = var.region
}

resource "random_shuffle" "zone" {
  input        = data.google_compute_zones.THEREQUIREDINSTANCEgcz.names
  result_count = 1
}

data "external" "ssh_key" {
  program = ["bash", "GCPSCOPE4VAL", "${var.key_path}"]
}

variable "key_path" {
  description = "The path where the SSH key will be stored"
  default     = "GCPSCOPE5VAL"
}

data "google_compute_network" "THE1VAL1HASHvpc" {
  name = "THE1VAL1HASHvpc"
}

data "google_compute_subnetwork" "THE1VAL1HASHsnt" {
  region    = var.region
  #network   = data.google_compute_network.THE1VAL1HASHvpc.name
  name      = "THE1VAL1HASHsnt"
}

resource "google_compute_instance" "THEREQUIREDINSTANCEvm" {
  count        		= var.instance_count
  name         		= "THEREQUIREDINSTANCEvm-${count.index}"
  machine_type 		= "GCPSCOPE6VAL"
  zone         		= GCPSCOPE7VAL  
  can_ip_forward      	= true
  deletion_protection 	= false
  enable_display      	= false
  
  boot_disk {
    auto_delete = true
    device_name = "THEREQUIREDINSTANCEbd"

    initialize_params {
      image = "GCPSCOPE8VAL"
      size  = GCPSCOPE9VAL
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }
  
  network_interface {
    network = data.google_compute_network.THE1VAL1HASHvpc.name
    subnetwork = data.google_compute_subnetwork.THE1VAL1HASHsnt.name

    access_config {
      
    }
  }

  metadata = {
    "startup-script" = <<-EOF
      #!/bin/bash
      if command -v apt-get &>/dev/null; then
        PKG_MANAGER='apt-get'
        SUDO_GROUP='sudo'
      elif command -v yum &>/dev/null; then
        PKG_MANAGER='yum'
        SUDO_GROUP='wheel'
      fi

      GCPSCOPE14VALuseradd -m -s /bin/bash GCPSCOPE13VAL
      GCPSCOPE14VALmkdir -p /home/GCPSCOPE13VAL/.ssh
      echo "${data.external.ssh_key.result["public_key"]}" > GCPSCOPE14VAL/home/GCPSCOPE13VAL/.ssh/authorized_keys
      GCPSCOPE14VALchown -R GCPSCOPE13VAL:GCPSCOPE13VAL /home/GCPSCOPE13VAL/.ssh
      GCPSCOPE14VALchmod 700 /home/GCPSCOPE13VAL/.ssh
      GCPSCOPE14VALchmod 600 /home/GCPSCOPE13VAL/.ssh/authorized_keys
      GCPSCOPE14VALusermod -aG $SUDO_GROUP GCPSCOPE13VAL
      echo 'GCPSCOPE13VAL ALL=(ALL) NOPASSWD:ALL' > GCPSCOPE14VAL/etc/sudoers.d/GCPSCOPE13VAL
    EOF
    "ssh-keys" = "GCPSCOPE13VAL:${data.external.ssh_key.result["public_key"]}"
  }

  depends_on = [
    data.external.ssh_key
  ]
}

output "public_ips" {
  value = google_compute_instance.THEREQUIREDINSTANCEvm.*.network_interface.0.access_config.0.nat_ip
}

output "hostnames" {
  value = google_compute_instance.THEREQUIREDINSTANCEvm.*.name
}

variable "instance_count" {
  description = "Number of instances to create"
  default     = GCPSCOPE10VAL
}

variable "region" {
  description = "The region for cloud resources"
  default     = "GCPSCOPE11VAL"
}

GCPSCOPE12VAL

