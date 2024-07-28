variable "project_name" {
  type = string
}

variable "project_environment" {
  type    = string
  default = "development"
}

variable "cors_allowed_headers" {
  type    = list(string)
  default = ["*"]
}

variable "cors_allowed_methods" {
  type    = list(string)
  default = ["GET", "HEAD", "POST"]
}

variable "cors_expose_headers" {
  type    = list(string)
  default = []
}

variable "cors_allowed_origins" {
  type    = list(string)
  default = ["*"]
}

variable "cors_max_age_seconds" {
  type    = number
  default = 3000
}

variable "policy_block_public_acls" {
  type    = bool
  default = false
}

variable "policy_ignore_public_acls" {
  type    = bool
  default = false
}

variable "policy_block_public_policy" {
  type    = bool
  default = false
}

variable "policy_restrict_public_buckets" {
  type    = bool
  default = false
}

variable "price_class" {
  type    = string
  default = "PriceClass_100"
}

variable "viewer_protocol_policy" {
  type    = string
  default = "redirect-to-https"
}

variable "is_ipv6_enabled" {
  type    = bool
  default = true
}

variable "compress" {
  type    = bool
  default = false
}
