variable "name" {
  type = string
}

variable "api_endpoint" {
  type = string
}

variable "api_method" {
  type = string
}

variable "api_invocation_rate_limit_per_second" {
  type    = number
  default = 300
}

variable "schedule_expression" {
  type = string
}
