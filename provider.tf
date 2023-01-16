terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.4.0"
    }
  }
  backend "s3" {
    bucket         = "ecs-terraform-examplecom-state"
    key            = "example/com.tfstate"
    region         = "eu-west-1"
    encrypt        = "true"
    dynamodb_table = "ecs-terraform-remote-state-dynamodb"
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
