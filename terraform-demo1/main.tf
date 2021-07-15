terraform {
  required_version = "~> 1.0.2"
  required_providers {
    google = ">=3.33.0"
  }
}

provider "google" {
  project = "gcp-terraform-319807"
  region  = "asia-northeast1"
}

data "google_compute_zones" "available" {
}

resource "google_compute_instance" "default" {
  count = length(data.google_compute_zones.available.names)

  name         = "test-${count.index}"
  machine_type = "f1-micro"
  zone         = data.google_compute_zones.available.names[count.index]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
  }
}

output "instance_names" {
  description = "Name of instances"
  value       = google_compute_instance.default[*].name
}

output "instance_zones" {
  description = "Zone of instances"
  value       = google_compute_instance.default[*].zone
}

