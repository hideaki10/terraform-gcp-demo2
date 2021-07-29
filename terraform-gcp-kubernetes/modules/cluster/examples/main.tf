module "cluster" {
  source = "../../cluster"

  service_name    = var.service_name
  service_viewers = []
  environment     = "dev"
}
