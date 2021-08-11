terraform {
  required_version = "~> 1.0.2"
  required_providers {
    google = ">= 3.33.0"
  }
}

locals {
  service_name_with_env = "${var.service_name}-${var.environment}"
}

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace
resource "kubernetes_namespace" "microservice" {
  metadata {
    name = local.service_name_with_env
    labels = {
      namespace = local.service_name_with_env
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding
resource "kubernetes_role_binding" "service_admins_is_view" {
  for_each = toset(var.service_viewers)

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    name      = "view"
    kind      = "ClusterRole"
  }

  metadata {
    name      = "${replace(each.key, "/@.*/", "")}-is-view"
    namespace = kubernetes_namespace.microservice.metadata[0].name
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "User"
    name      = each.key
    namespace = ""
  }
}

resource "kubernetes_role_binding" "service_admins_is_admin" {
  for_each = toset(var.service_admins)

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    name      = "edit"
    kind      = "ClusterRole"
  }

  metadata {
    name      = "${replace(each.key, "/@.*/", "")}-is-edit"
    namespace = kubernetes_namespace.microservice.metadata[0].name
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "User"
    name      = each.key
    namespace = ""
  }
}

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account
resource "kubernetes_service_account" "pod_default" {
  metadata {
    name      = "pod-default"
    namespace = kubernetes_namespace.microservice.metadata[0].name

    annotations = {
      "iam.gke.io/gcp-service-account" = "${google_service_account.pod_default.account_id}@${module.project.project_id}.iam.gserviceaccount.com"
    }
  }
}

resource "google_service_account" "pod_default" {
  account_id   = "pod-default"
  display_name = "pod-default"
  project      = module.project.project_id
}

resource "google_service_account_iam_binding" "pod_default_is_workload_identity_user" {
  service_account_id = google_service_account.pod_default.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.gke_project}.svc.id.goog[${kubernetes_namespace.microservice.metadata[0].name}/${kubernetes_service_account.pod_default.metadata[0].name}]"
  ]
}

# https://www.terraform.io/docs/providers/google/r/artifact_registry_repository.html
resource "google_artifact_registry_repository" "container" {
  provider = google-beta

  project = module.project.project_id

  location      = var.gcp_region
  repository_id = "container"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "pod_default_is_artifact_registry_reader" {
  provider = google-beta

  project = module.project.project_id

  location   = google_artifact_registry_repository.container.location
  repository = google_artifact_registry_repository.container.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.pod_default.email}"
}

# https://www.terraform.io/docs/providers/google/r/bigquery_dataset.html
resource "google_bigquery_dataset" "container_log" {
  location = var.gcp_region

  dataset_id = "container_log"
  project    = module.project.project_id
}

# https://www.terraform.io/docs/providers/google/r/logging_project_sink.html
resource "google_logging_project_sink" "from_container_to_bq" {
  name    = "from-container-to-bq"
  project = var.gke_project

  destination            = "bigquery.googleapis.com/projects/${module.project.project_id}/datasets/${google_bigquery_dataset.container_log.dataset_id}"
  filter                 = "resource.type=k8s_container AND resource.labels.namespace_name=${module.project.project_id}"
  unique_writer_identity = true
}

module "project" {
  source = "../project"

  gcp_project     = local.service_name_with_env
  billing_account = var.billing_account
}
