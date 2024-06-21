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

data "google_compute_zones" "THE1VAL1HASHgcz" {
  region = var.region
}

resource "google_compute_network" "THE1VAL1HASHvpc" {
  name                    = "THE1VAL1HASHvpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "THE1VAL1HASHsnt" {
  name          = "THE1VAL1HASHsnt"
  region        = var.region
  network       = google_compute_network.THE1VAL1HASHvpc.id
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_firewall" "THE1VAL1HASHfw1" {
  name    = "THE1VAL1HASHfw1"
  network = google_compute_network.THE1VAL1HASHvpc.name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  
  allow {
    protocol = "tcp"
    ports    = ["22", GCPSCOPE3VAL]
  }

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "THE1VAL1HASHfw2" {
  name    = "THE1VAL1HASHfw2"
  network = google_compute_network.THE1VAL1HASHvpc.name
  direction = "EGRESS"
  source_ranges = ["0.0.0.0/0"]
  
  allow {    
    protocol  = "all"
    ports     = []
  }
}

variable "region" {
  description = "The region for cloud resources"
  default     = "GCPSCOPE11VAL"
}

variable "THE1VAL1HASHgbn" {
  description = "Google Cloud Storage Global Bucket"
  type        = string
  default     = "gcpTHEGLOBALBUCKET"
}

resource "google_storage_bucket" "THE1VAL1HASHgcb" {
  name     = var.THE1VAL1HASHgbn
  location = var.region
  force_destroy = true
}

