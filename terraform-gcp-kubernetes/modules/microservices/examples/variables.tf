variable "cluster_tfstate_bucket" {
  type        = string
  description = "GCS bucket for kubernetes cluster terraform state"
}

variable "cluster_tfstate_prefix" {
  type        = string
  description = "GCS prefix for kubernetes cluster terraform state"
}

variable "service_name" {
  type        = string
  description = "Name of a microservice"
}
