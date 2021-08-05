module "cluster" {
  source = "../"

  service_name    = var.service_name
  service_viewers = []
  environment     = "dev"
}
