variable "project" {
  description = "gcp project"
  type        = string
  default     = null
}


variable "region" {
  description = "region"
  type        = string
  default     = "asia-northeast1"

  # validation {
  #   condition     = var.region == "asia-northeast1"
  #   error_message = "The region must be asia-northeast1."
  # }
}

variable "zone" {
  description = "A zone to use the module"
  type        = string
  default     = "asia-northeast1-a"

  # validation {
  #   condition = contains(
  #     ["asia-northeast1-a", "asia-northeast1-b", "asia-northeast1-c"], var.zone
  #   )
  #   error_message = "The zone must be in asia-northeast1-a."
  # }
}
