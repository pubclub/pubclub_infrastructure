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
  bucket = var.artifact_bucket
}

module "pubclub-users" {
  for_each = var.confirmation_lambda_config

  source         = "../modules/cognito"
  user_pool_name = "pubclub-users"
  schema = [
    {
      name = "email"
    },
    {
      name = "name"
    },
  ]
  region                = var.region
  project_id            = var.project_id
  lambda_function_name  = each.value.function_name
  user_pool_client_name = "pubclub-userpool-client"
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

module "confirmation_function" {
  for_each              = var.confirmation_lambda_config
  source                = "../modules/lambda_function"
  bucket_name           = var.artifact_bucket
  filename              = each.value.filename
  function_name         = each.value.function_name
  function_iam_name     = each.value.function_iam_name
  environment_variables = each.value.environment_variables
}

module "ratings-function" {
  for_each              = var.ratings_lambda_config
  source                = "../modules/lambda_function"
  bucket_name           = var.artifact_bucket
  filename              = each.value.filename
  function_name         = each.value.function_name
  function_iam_name     = each.value.function_iam_name
  environment_variables = each.value.environment_variables
}
