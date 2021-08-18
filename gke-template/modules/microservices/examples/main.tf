module "microservice" {
  source = "../"

  gke_project     = data.terraform_remote_state.cluster.outputs.gke_project_id
  service_name    = var.service_name
  environment     = "dev"
  billing_account = var.billing_account
}

// https://www.terraform.io/docs/providers/terraform/d/remote_state.html
data "terraform_remote_state" "cluster" {
  backend = "gcs"

  config = {
    bucket = var.cluster_tfstate_bucket
    prefix = var.cluster_tfstate_prefix
  }
}

# https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/auth
data "google_client_config" "provider" {}

# https://github.com/niallthomson/tanzu-playground/blob/4789e19da2b262c5de076fcd09778a0c92cf0c92/terraform/gke/cf-for-k8s/providers.tf
provider "kubernetes" {
  //load_config_file = false

  host  = "https://${data.terraform_remote_state.cluster.outputs.gke_endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.cluster.outputs.gke_ca_certificate,
  )
}

provider "google" {  
  project = "gcp-terraform-319807"
  region  = var.gcp_project
}

provider "google-beta" {
    project = "gcp-terraform-319807"
  region  = var.gcp_project
}
