variable "user_pool_name" {
  type = string
}

variable "schema" {
  type = set(object({
    name = string
  }))
}

variable "region" {
  type = string
}

variable "project_id" {
  type = string
}

variable "lambda_function_name" {
  type        = string
  description = "Name of lambda function called following post-confirmation"
}

variable "user_pool_client_name" {
  type = string
}
