
module "project" {
  source          = "../../project"
  gcp_project     = var.project_id
  billing_account = var.billing_account
}
