# 2. Record architecture decisions

Date: 2022-01-27

## Status

Accepted

## Context

Terraform 1.1 introduced a new way of configuring Terraform in the context of Terraform Cloud. This is documented here [cloud {} "backend"](https://www.terraform.io/cli/cloud/settings). With our terraform repositories having long-running branches, being able to pick which Terraform Cloud Workspace to use as the backend/remote run from the local developer's CLI is very important. If we don't make this switch, there is no way for a local developer to run a speculative plan in any cloud workspace other than the "-dev" one.

Neither the `cloud { }` block nor the `backend "remote" { }` block are read when terraform is run in Terraform Cloud. These are purely for local cli-triggered runs of terraform for an infra developer working through code.

## Decision

We will switch our Terraform repositories from using a `backend "remote" { }` block in the `terraform { }` resource to a `cloud { }` block with workspaces declared via tags, not names.

## Consequences

1. Local infra developers will be able to run speculative plans from the local cli in different Terraform Cloud workspaces for a single GitHub repository (via the TF_WORKSPACE environement variable or the `terraform workspace select <>` command).
1. For this to work properly, we will need to update our use of tags in Terraform Cloud in order to group workspaces by repository name.
1. For this to work properly, we will need to declare the correct tags in the `cloud { }` block in the `terraform { }` resource.
1. Local infra devs will need to continue to use the "terraform workspace" option when running speculative plans.
1. We will need to update the GitHub template repo for our Terraform repositories.
