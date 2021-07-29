module "project" {
  source = "../project"

  gcp_project = local.service_name_with_env
}

locals {
  service_name_with_env = "${var.service_name}-${var.envrionment}"
}

// kubernetes controller plan
resource "google_container_cluster" "primary" {

  name     = "primary"
  project  = module.project.project_id
  location = var.gcp_region

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = ""
    services_ipv4_cidr_block = ""
  }

  workload_identity_config {
    identity_namespace = "${module.project.project_id}.svc.id.goog"
  }

  initial_node_count       = 1
  remove_default_node_pool = true
}


resource "google_container_node_pool" "primary" {
  name     = "primary"
  source   = module.project.project_id
  location = var.gcp_region

  cluster    = google_container_cluster.primary.name
  node_count = 1
  node_config {
    preemtible   = true
    machine_type = "e2-medium"
  }
  workload_identity_config {
    node_metadata = "GKE_METADATA_SERVER"
  }

  metadata = {
    disable-legacy-endpoints = "true"
  }

  oauth_scopes = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]

  lifecycle {
    ignore_changes = [node_count]
  }
}

