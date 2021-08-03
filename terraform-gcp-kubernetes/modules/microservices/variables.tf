variable "service_name" {
  description = "A service name of the service"
  type        = string
}

variable "environment" {
  description = "environment of the service"
  type        = string

  validation {
    condition     = contains(["dev", "prod", var.environment])
    error_message = "The environment must be dev or prod."
  }
}

variable "service_viewers" {
  description = "Views of the microservice"
  type        = list(string)

  default = []
}

variable "service_admins" {
  description = "Admins of the microservice"
  type        = list(string)
  default     = []
}

variable "gke_project_id" {
  description = "Name of GKE project"
  type        = string
}

variable "gcp_additional_enabled_services" {
  description = "Additional GCP API services to be enabled per project"
  type        = list(string)

  default = []
}

