terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }
  backend "s3" {
    bucket = "pubclub-tf-state"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  region                   = var.region
  shared_credentials_files = [var.credentials_file]
}

# Bucket for storing app artifacts e.g. builds for lambda functions
resource "aws_s3_bucket" "pubclub-artifacts" {
  bucket = "pubclub-artifacts"
}

resource "aws_cognito_user_pool" "pubclub-users" {
  name = "pubclub-users"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length = 6
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  lambda_config {
    post_confirmation = "arn:aws:lambda:${var.region}:${var.project_id}:function:${var.function_name}"
  }

}

module "ratings-table" {
  source         = "../modules/dynamodb"
  table_name     = "ratings-table"
  partition_key  = "RatingId"
  sort_key       = "CreationDate"
  read_capacity  = 5
  write_capacity = 5
  attributes = [
    {
      name = "RatingId",
      type = "S",
    },
    {
      name = "CreationDate",
      type = "S",
    },
    {
      name = "UserId",
      type = "S",
    },
    {
      name = "PlaceId",
      type = "S",
    },
  ]
  secondary_indices = [
    {
      name            = "UserIdIndex",
      hash_key        = "UserId",
      projection_type = "ALL",
    },
    {
      name            = "PlaceIdIndex",
      hash_key        = "PlaceId",
      projection_type = "ALL",
    },
  ]
}

module "user-table" {
  source         = "../modules/dynamodb"
  table_name     = "users-table"
  partition_key  = "UserId"
  sort_key       = null
  read_capacity  = 5
  write_capacity = 5
  attributes = [
    {
      name = "UserId",
      type = "S",
    },
  ]
  secondary_indices = []
}
