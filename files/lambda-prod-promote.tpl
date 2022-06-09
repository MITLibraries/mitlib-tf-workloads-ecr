### This is the Terraform-generated prod-promote.yml workflow for the ${function} app repository ###
name: Prod Promote Lambda Container
on:
  workflow_dispatch:
  release:
    types: [published]

jobs:
  deploy:
    name: Prod Promote Lambda Container
    uses: mitlibraries/.github/.github/workflows/lambda-shared-promote-prod.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE_STAGE: ${role_stage}
      GHA_ROLE_PROD: ${role_prod}
      ECR: "${ecr}"
      FUNCTION: "${function}"
