//project
resource "google_project" "service" {
  name            = var.gcp_project
  project_id      = var.gcp_project
  billing_account = var.billing_account
  skip_delete     = false
}

//project_service 
//config the api 
resource "google_project_service" "gcp_api_service" {
  for_each           = toset((concat(var.gcp_default_enabled_services, var.gcp_additional_enable_services)))
  project            = google_project.microservice.project_id
  service            = each.key
  disable_on_destroy = false
}


resource "google_project_iam_member" "service_viewers" {
  for_each = toset(var.service_viewers)
  project  = google_project.microservice.project_id
  role     = "roles/viewer"
  member   = "user:${each.key}"
}

resource "google_project_iam_member" "service_admins" {
  for_each = toset(var.service_admins)
  project  = google_project.microservice.project_id
  role     = "roles/editor"
  member   = "user:${each.key}"
}

