variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "gateway_name" {
  type        = string
  description = "Name of API Gateway"
}

variable "cognito_arn" {
  type        = string
  description = "ARN of cognito user pool"
}

variable "lambda_function_name" {
  type        = string
  description = "Name of lambda function to deploy to API"
}
