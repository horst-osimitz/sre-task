terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "<= 5.72.1" # https://github.com/hashicorp/terraform-provider-aws/issues/40091
    }
  }

  backend "s3" {
    bucket = "tf-backend-rgitoh"
    key    = "demo/ec2/terraform.tfstate"
    region = "eu-central-1"
  }
}

