terraform {
  required_version = "1.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.12.0"
    }
  }

  backend "s3" {
    bucket = "mlb-notice-tfstate"
    region = "ap-northeast-1"
  }
}
