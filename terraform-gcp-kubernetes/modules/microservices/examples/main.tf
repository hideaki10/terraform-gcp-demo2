module "microservices" {
  source          = "../../../modules/microservices"
  gke_project_id  = data.terraform_remote_state.cluster.outputs.gke_project_id
  service_name    = var.service_name
  environment     = "dev"
  billing_account = var.billing_account
  region          = var.region
}

# data "terraform_remote_state" "cluster" {
#   backend = "gcs"
#   config = {
#     bucket = var.cluster_tfstate_bucket
#     prefix = var.cluster_tfstate_prefix
#   }
# }
data "terraform_remote_state" "cluster" {
  backend = "gcs"
  config = {
    bucket = var.cluster_tfstate_bucket
    prefix = var.cluster_tfstate_prefix
  }
}
data "google_client_config" "provider" {}


provider "kubernetes" {
  //load_config_file = false
  host  = "https://${data.terraform_remote_state.cluster.outputs.gke_endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.cluster.outputs.gke_ca_certificate,
  )
}
