output "gke_project_id" {
  description = "gke project"
  value       = module.project.project_id
}

output "gke_endpoint" {
  description = "endpoint of gke project"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "gke_ca_certificate" {
  description = "certificate "
  value       = google_container_cluster.primary.master_auth.0.cluster_certficate
  sensitive   = true
}
