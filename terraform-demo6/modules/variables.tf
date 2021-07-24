variable "project" {
  description = "variable"
  type        = string
  default     = null
}

variable "zone" {
  description = "zone"
  type        = string
  default     = "asia-northeast1-a"

}

variable "service_name" {
  description = "A name of the service."
  type        = string
}

variable "environment" {
  description = "An ervironment of a service"
  type        = string
  default     = "development"

  validation {
    condition = contains(
    ["development", "staging", "production"], var.environment)
    error_message = "The zone must be in asia-region."
  }
}

variable "machine_type" {
  description = "A machine type of a compute instance"
  type        = string
  default     = "f1-micro"
}


