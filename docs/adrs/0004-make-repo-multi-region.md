# 4. Make repository mulit-region capable

Date: 2025-05-06

## Status

Proposed

## Context

We are now at the place in our infrastructure that we need to be able to deploy ECR repositories in  multiple AWS regions so that we can deploy containerized applications (Fargate & Lambda) in mulitple regions. This is primarly driven by the CDPS project, but will be available to any other project that expects containers in more than just `us-east-1`.

As we extend this to multiple regions, it is **very import** that we do not modify any of the existing outputs from this repository, either to SSM Parameter Store or to Terraform Cloud outputs -- too many other repositories are already dependent on those values and would all need refactoring if any of the outputs change.

## Decision

1. Add additional provider blocks in the root of the repository, as needed.
1. Update the embedded `ecr` module to handle ECR repository creation for containers that need to be deployed in multiple AWS regions.
1. Update the generated GHA workflows and Makefile outputs to support multiple AWS regions.

## Consequences

If this is done correctly, there will be no consequences.