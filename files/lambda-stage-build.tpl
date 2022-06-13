### This is the Terraform-generated stage-build.yml workflow for the ${function} repository ###
name: Stage Build and Deploy Lambda Container
on:
  workflow_dispatch:
  push:
    branches:
      - main
    paths-ignore:
      - '.github/**'

jobs:
  deploy:
    name: Stage Deploy Lambda Container
    uses: mitlibraries/.github/.github/workflows/lambda-shared-deploy-stage.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE: "${role}"
      ECR: "${ecr}"
      FUNCTION: "${function}"
