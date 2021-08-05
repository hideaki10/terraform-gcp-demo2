module "cluster" {
  source = "../../modules/cluster"

  service_name    = "test-tfstate-20210804-01"
  environment     = "dev"
  billing_account = var.billing_account
}

provider "google" {
  project = var.gcp_project
  region  = var.region
}

provider "google-beta" {
  project = var.gcp_project
  region  = var.region
}


terraform {
  backend "gcs" {
    bucket = "test-tfstate-20210804"
    prefix = "terraform/k8s-cluster/terraform_state"
  }

  required_providers {
    google      = ">=3.34.0"
    google-beta = ">=3.34.0"
  }
}
