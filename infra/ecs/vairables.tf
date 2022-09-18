variable "node_app_image_url" {}

variable "ecs_service_network_configuration" {
  type = object({
    subnets          = list(string)
    assign_public_ip = bool
  })
  default = {
    subnets          = []
    assign_public_ip = false
  }
}

variable "node_app_env" {
  //  type = object({
  //    DB_TYPE     = string
  //    DB_HOST     = string
  //    DB_PORT     = number
  //    DB_USERNAME = string
  //    DB_PASSWORD = string
  //    PORT        = number
  //    TEST_TOKEN  = string
  //  })
}

variable "region" {}

variable "aws_cloudwatch_log_group" {}
