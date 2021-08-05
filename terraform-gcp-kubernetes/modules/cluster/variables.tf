variable "service_name" {
  description = "A service name of the service"
  type        = string
}

variable "environment" {
  description = "Enviornment of the microservice"
  type        = string

  //命名規則
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment must be dev or prod."
  }
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "asia-northeast1"
}

variable "gcp_additional_enabled_services" {
  description = "Additional GCP API services to be enable per project"
  type        = list(string)
  default     = []
}

variable "service_viewers" {
  description = "viewers"
  type        = list(string)
  default     = []
}

variable "service_admins" {
  description = "admins"
  type        = list(string)
  default     = []
}



variable "billing_account" {
  description = "Billing account for the GCP project"
  type        = string
}
