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
  region                   = "eu-west-2"
  shared_credentials_files = ["$HOME/.aws/credentials"]
}

resource "aws_dynamodb_table" "ratings-table" {
  name           = "ratings-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "RatingId"
  range_key      = "CreationDate"

  attribute {
    name = "RatingId"
    type = "S"
  }

  attribute {
    name = "CreationDate"
    type = "S"
  }

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "PlaceId"
    type = "S"
  }

  global_secondary_index {
    name            = "UserIdIndex"
    hash_key        = "UserId"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }

  global_secondary_index {
    name            = "PlaceIdIndex"
    hash_key        = "PlaceId"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }

}
