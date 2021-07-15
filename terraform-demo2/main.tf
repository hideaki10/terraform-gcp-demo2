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
  for_each = toset(data.google_compute_zones.available.names)

  name         = "test-${each.key}"
  machine_type = "f1-micro"
  zone         = each.value

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
  value       = values(google_compute_instance.default)[*].name
}

output "instance_zones" {
  description = "Zone of instances"
  value       = values(google_compute_instance.default)[*].zone
}
