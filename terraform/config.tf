# Terraform and providers configuration

terraform {
  required_version = ">= 1.0"

  backend "s3" {
    region = "ap-southeast-2"

    bucket = "epicwink-private-misc"
    key    = "terraform-states/epicwink-website.tfstate"

    dynamodb_table = "terraform-state-locks"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      managed = "epicwink/website:terraform"
    }
  }
}

provider "aws" {
  alias  = "north_virginia"
  region = "us-east-1"

  default_tags {
    tags = {
      managed = "epicwink/website:terraform"
    }
  }
}

data "aws_caller_identity" "current" {
}
