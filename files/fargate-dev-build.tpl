### This is the Terraform-generated dev-build.yml workflow for the ${ecr} app repository ###
name: Dev Build and Deploy Fargate Container
on:
  workflow_dispatch:
  pull_request:
    branches:
      - main
    paths-ignore:
      - '.github/**'

jobs:
  deploy:
    name: Dev Deploy Fargate Container
    uses: mitlibraries/.github/.github/workflows/fargate-shared-deploy-dev.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE: "${role}"
      ECR: "${ecr}"
