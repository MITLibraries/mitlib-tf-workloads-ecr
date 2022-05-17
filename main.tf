################################################################################
# main.tf for basic Terraform config.
################################################################################
# We use the new Terraform 1.1 `cloud{}` block along with TfC workspace
# tags to link this repo to multiple TfC workspaces. This allows the 
# local infra dev to link cli-driven speculative plans to the appropriate
# workspace in TfC.

terraform {
  cloud {
    organization = "MITLibraries"

    workspaces {
      # In most cases there should be two tags set here: 
      # The short name of the repository and the name of the AWS OU
      tags = ["", ""]
    }
  }
}

# The following is part of the default naming scheme for resources created
# by Terraform. This defaults to null, but should be updated if this 
# infrastructure is part of a large project. Note that this value is used in 
# the providers.tf file.
locals {
  project_id = null # change to "project-id-name" if this is part of a larger project
}
