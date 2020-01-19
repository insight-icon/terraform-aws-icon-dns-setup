
variable "environment" {
  type = string
  default = "dev"
}

variable "name" {
  type = string
  default = "Regional internal DNS zone"
}

variable "vpc_ids" {
  type = list(string)
  default = []
}

variable "zone_id" {
  type = string
  default = ""
}

variable "force_destroy" {
  type = bool
  default = true
}

variable "root_domain_name" {
  description = "The domain name to use for internal dns"
  type = string
}

variable "internal_domain_name" {
  description = "The domain name to use for internal dns"
  type = string
}

variable "create_public_regional_subdomain" {
  type = bool
  default = false
}

variable "create_private_regional_subdomain" {
  type = bool
  default = false
}

variable "tags" {
  type = map(string)
  default = {}
}
