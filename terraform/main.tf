terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "myvcn" {
  name                    = "myvcn"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subad1" {
  name          = "subad1"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.myvcn.id
}

resource "google_compute_firewall" "lab_allow_web" {
  name    = "terraform-lab-allow-web"
  network = google_compute_network.myvcn.name

  allow {
    protocol = "tcp"
    ports = [
      "22",
      "80",
      "443",
      "8080",
      "8072",
      "3001"
    ]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = [
    "terraform-lab"
  ]
}

resource "google_compute_instance" "lab_vm" {
  name         = "terraform-lab-vm"
  machine_type = "e2-medium"
  zone         = var.zone

  tags = [
    "terraform-lab"
  ]

  boot_disk {
    initialize_params {
      image = "projects/oracle-linux-cloud/global/images/family/oracle-linux-9"
      size  = 20
    }
  }

  network_interface {
    network    = google_compute_network.myvcn.id
    subnetwork = google_compute_subnetwork.subad1.id

    access_config {}
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = file("${path.module}/../bootstrap/startup.sh")

  service_account {
    scopes = [
      "cloud-platform"
    ]
  }
}

output "vm_public_ip" {
  value = google_compute_instance.lab_vm.network_interface[0].access_config[0].nat_ip
}

output "vm_private_ip" {
  value = google_compute_instance.lab_vm.network_interface[0].network_ip
}

output "ssh_command" {
  value = "gcloud compute ssh ${google_compute_instance.lab_vm.name} --zone=${var.zone}"
}

output "vpc_name" {
  value = google_compute_network.myvcn.name
}

output "subnet_name" {
  value = google_compute_subnetwork.subad1.name
}

output "subnet_cidr" {
  value = google_compute_subnetwork.subad1.ip_cidr_range
}