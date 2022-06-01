################################################################################
# All version requirements for Terraform and Terraform Providers are set here.
# Providers themselves are set in the `providers.tf` file.

terraform {
  required_version = "~> 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
