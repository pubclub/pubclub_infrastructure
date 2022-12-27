variable "region" {
  type = string
}

variable "project_id" {
  type = string
}

variable "credentials_file" {
  type        = string
  description = "Path to file containing AWS credentials"
}

variable "artifact_bucket" {
  type        = string
  description = "Name of bucket to store project artifacts (e.g. builds)"
}

variable "ratings-table-name" {
  type        = string
  description = "Name for ratings table"
}

variable "confirmation_lambda_config" {
  description = "Map of configuration options for the Lambda function for writing post-confirmation users to DynamoDB"
  type = map(object({
    filename              = string
    function_name         = string
    function_iam_name     = string
    environment_variables = map(string)
  }))
  default = {}
}

variable "ratings_lambda_config" {
  description = "Map of configuration options for the Lambda function for handling ratings"
  type = map(object({
    filename              = string
    function_name         = string
    function_iam_name     = string
    environment_variables = map(string)
  }))
  default = {}
}
