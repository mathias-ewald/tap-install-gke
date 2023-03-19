variable "region" {
  type = string
}

variable "project_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "zones" {
  type = list(any)
}
