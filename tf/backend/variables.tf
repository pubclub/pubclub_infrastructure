variable "region" {
  type = string
}

variable "credentials_file" {
  type        = string
  description = "Path to file containing AWS credentials"
}

variable "ratings-table-name" {
  type        = string
  description = "Name for ratings table"
}
