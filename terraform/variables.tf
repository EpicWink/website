# Terraform deployment configuration

variable "additional_domain_names" {
  default     = []
  description = "Additional website domain names"
  type        = list(string)
}

variable "domain_name" {
  default     = "www.epicwink.au"
  description = "Primary website domain name"
  type        = string
}
