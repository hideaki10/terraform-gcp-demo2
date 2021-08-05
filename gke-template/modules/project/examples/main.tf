module "project" {
  source = "../"

  gcp_project = var.project_id
  billing_account = var.billing_account
}
