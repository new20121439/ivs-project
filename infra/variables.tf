variable "region" {
  type = string
}

variable "environment" {
  type        = string
  description = "environment should be production | development | test"
}

variable "domain_name" {
  type = string
}

variable "website_bucket_name" {
  type = string
}

variable "test_token" {
  type = string
}
