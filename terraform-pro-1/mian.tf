resource "google_compute_instance_template" "default" {
  name_prefix  = "default-"
  machine_type = "f1-micro"
  region       = var.region

  // boot disk
  disk {
    source_image = "debian-cloud/debian-9"
  }

  // networking
  network_interface {
    network = "default"
  }


}

resource "google_compute_instance_group_manager" "default" {
  name = "default"
  version {
    instance_template = google_compute_instance_template.default.self_link
  }

  base_instance_name = "mig"
  zone               = var.zone
  target_size        = "6"
}

resource "google_compute_region_autoscaler" "default"{
  name = "default"

  target = google_compute_instance_group_manager.default.self_link

  autoscaling_policy{
    max_replicas = 10
    min_replicas = 6
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}