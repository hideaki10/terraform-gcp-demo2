variable "gcp_project" {
  description = "GCP project name"
  type        = string

}

// 持ってないためコマンドアウト
# variable "gcp_org" {
#   description = "GCP organzation id"
#   type        = string

# }


variable "billing_account" {
  description = "Billing account for the GCP project"
  type        = string
}

//通用api
variable "gcp_default_enable_services" {
  description = "GCP API services tp be enabled by default"
  type        = list(string)

  default = ["audit.googleapis.com",
    "bigquery.googleapis.com",
    "bigquerystorage.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
    "stackdriver.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
  "artifactregistry.googleapis.com", ]
}

//追加api 用于 microservice 
variable "gcp_additional_enable_services" {
  description = "Additional GCP API services to be enabled per project"
  type        = list(string)
  default     = []
}

variable "service_viewers" {

  description = "Viewers of ther microservice"

  type = list(string)

  default = []

}

variable "service_admins" {
  description = "Admins of the microservice"
  type        = list(string)
  default     = []
}
