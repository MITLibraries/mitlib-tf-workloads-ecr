### This is the Terraform-generated dev-build.yml workflow for the ${function} app repository ###
name: dev Build and Deploy lambda Container
on:
  workflow_dispatch:
  pull_request:
    branches:
      - main
    paths-ignore:
      - '.github/**'

jobs:
  deploy:
    name: dev Deploy lambda Container
    uses: mitlibraries/.github/.github/workflows/lambda-shared-deploy-dev.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE: "${role}"
      ECR: "${ecr}"
      FUNCTION: "${function}"
