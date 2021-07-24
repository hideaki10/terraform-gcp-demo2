resource "google_compute_instance" "after-mv" {
  name         = "test"
  machine_type = "f1-micro"

  project = "gcp-terraform-319807"
  zone    = "asia-northeast1-a"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
  }
}
