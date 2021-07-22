terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "<aws-s3-bucket>"
    key    = "state/terraform_state.tfstate"
    region = "ap-northeast-1"
    profile = "<aws-iam-profile>"
  }
}

provider "aws" {
  region = var.aws_region
  profile = "<aws-iam-profile>"
}