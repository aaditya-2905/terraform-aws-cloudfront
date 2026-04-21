variable "aliases" {
  type    = list(string)
  default = null
}

variable "origin" {
  type    = any
  default = {}
}

variable "origin_group" {
  type    = any
  default = {}
}

variable "origin_access_control" {
  type    = any
  default = {}
}

variable "default_cache_behavior" {
  type    = any
  default = null
}

variable "ordered_cache_behavior" {
  type    = any
  default = []
}

variable "custom_error_response" {
  type    = any
  default = []
}

variable "restrictions" {
  type    = any
  default = null
}

variable "viewer_certificate" {
  type    = any
  default = null
}

variable "response_headers_policy" {
  type    = any
  default = null
}

variable "custom_headers" {
  type    = any
  default = {}
}

variable "logging_config" {
  type    = any
  default = null
}

variable "log_delivery" {
  type    = any
  default = null
}

variable "vpc_origin" {
  type    = any
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
