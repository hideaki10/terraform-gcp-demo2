variable "cluster_tfstate_bucket" {
  type        = string
  description = "GCS bucket for Kubernetes cluster terraform state"
}

variable "cluster_tfstate_prefix" {
  type        = string
  description = "GCS prefix for Kubernetes cluster terraform state"
}

variable "service_name" {
  type        = string
  description = "Name of a microservice"
}


variable "billing_account" {

}
