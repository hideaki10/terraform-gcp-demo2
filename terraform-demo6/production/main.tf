terraform {
  backend "gcs" {
    bucket = "tf-state-senshikou-20210719-prod"
    prefix = "terraform/test_instance/state"
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

module "test_instance" {
  source = "../modules"

  project      = var.project
  zone         = var.zone
  service_name = "test-production"
  environment  = "production"
}
