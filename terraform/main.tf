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

resource "google_compute_firewall" "lab_allow_web" {
  name    = "terraform-lab-allow-web"
  network = "default"

  allow {
    protocol = "tcp"
    ports = [
      "22",
      "80",
      "443"
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
    network = "default"

    access_config {
    }
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

output "ssh_command" {
  value = "gcloud compute ssh ${google_compute_instance.lab_vm.name} --zone=${var.zone}"
}