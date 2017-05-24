variable "staging_origin_domain_name" {
  type = "string"
}

variable "staging_origin_path" {
  type = "string"
}

variable "staging_acm_certificate_arn" {
  type = "string"
}

variable "staging_origin_protocol_policy" {
  type = "string"
  default = "https-only"
}

variable "production_origin_domain_name" {
  type = "string"
}

variable "production_origin_path" {
  type = "string"
}

variable "production_acm_certificate_arn" {
  type = "string"
}

variable "production_origin_protocol_policy" {
  type = "string"
  default = "https-only"
}
