terraform {
  backend "gcs" {
    bucket = "tf-state-senshikou-20210719-dev"
    prefix = "terraform/state"
  }
}
provider "google" {
  project = "gcp-terraform-319807"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}
resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {

    network = "default"
  }
}
