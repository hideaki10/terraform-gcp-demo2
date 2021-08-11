module "cluster" {
  source = "../../modules/cluster"

  # 例: toshi0607-20201221-cluster
  service_name    = "test-gke-cluster-01"
  environment     = "dev"
  billing_account = var.billing_account
}

provider "google" {
  project = "gcp-terraform-319807"
  region  = var.gcp_project
}

provider "google-beta" {
  project = "gcp-terraform-319807"
  region  = var.gcp_project
}

terraform {
  backend "gcs" {
    bucket = "test-tfstate-20210804"
    prefix = "terraform/k8s-cluster/terraform_state"
  }

  required_providers {
    google      = ">= 3.34.0"
    google-beta = ">= 3.34.0"
  }
}
