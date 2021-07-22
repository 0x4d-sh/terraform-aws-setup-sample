# provider.tf | main configuration

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = var.aws_s3_bucket
    key    = "state/terraform_state.tfstate"
    region = "ap-northeast-1"
    profile = var.aws_iam_profile
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_iam_profile
}