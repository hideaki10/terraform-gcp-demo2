
module "project" {
  source          = "../../project"
  gcp_project     = var.gcp_project
  billing_account = var.billing_account
}
