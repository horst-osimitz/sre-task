terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "local" {
    path = "relative/path/to/terraform.tfstate"
  }
}

