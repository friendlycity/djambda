terraform {
  backend "remote" {
    organization = "friendlycity"

    workspaces {
      name = "djambda"
    }
  }
  required_version = "1.6.4"
}

provider "aws" {
  region = var.aws_region
}

provider "github" {}