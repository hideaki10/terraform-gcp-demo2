# https://cloud.google.com/compute/docs/regions-zones
variable "gcp_region" {
  type        = string
  description = "GCP region"
  default     = "asia-northeast1"
}

variable "service_name" {
  type = string
}

variable "gcp_additional_enabled_services" {
  description = "Additional GCP API services to be enabled per project"
  type        = list(string)

  default = []
}

variable "service_viewers" {
  description = "Viewers of the microservice"

  type    = list(string)
  default = []
}

variable "service_admins" {
  description = "Admins of the microservice"

  type    = list(string)
  default = []
}

variable "environment" {
  description = "Environment of the microservice"

  type = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment must be dev, stg or prod."
  }
}

variable "billing_account" {
  description = "Billing account for the GCP project"
  type        = string
  # default     = 【あなたのBilling account】
}