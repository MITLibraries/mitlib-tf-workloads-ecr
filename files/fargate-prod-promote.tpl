### This is the Terraform-generated prod-promote.yml workflow for the ${ecr_name} app repository ###
name: Prod Promote Fargate Container
on:
  workflow_dispatch:
  release:
    types: [published]

jobs:
  deploy:
    name: Prod Promote Fargate Container
    uses: mitlibraries/.github/.github/workflows/fargate-shared-promote-prod.yml@container-flows
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE_STAGE: ${role_stage}
      GHA_ROLE_PROD: ${role_prod}
      ECR: "${ecr}"
