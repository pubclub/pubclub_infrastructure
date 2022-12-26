variable "bucket_name" {
  type        = string
  description = "Name of S3 bucket where executable is found"
}

variable "filename" {
  type        = string
  description = "Path of executable file in S3 bucket"
}

variable "function_name" {
  type        = string
  description = "Name of lambda function"
}

variable "environment_variables" {
  type        = map(string)
  description = "Key-values for any environment variables to use in function"
}
