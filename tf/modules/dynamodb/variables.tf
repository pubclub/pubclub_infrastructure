variable "table_name" {
  type        = string
  description = "Name of DynamoDB table"
}

variable "partition_key" {
  type        = string
  description = "Primary key to partition data on"
}

variable "sort_key" {
  type        = string
  description = "Key to sort data on"
}

variable "read_capacity" {
  type = number
}

variable "write_capacity" {
  type = number
}

variable "attributes" {
  type = set(object({
    name = string
    type = string
  }))
}

variable "secondary_indices" {
  type = set(object({
    name            = string
    hash_key        = string
    projection_type = string
  }))
}
