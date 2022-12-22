terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
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
