### This is the Terraform-generated stage-build.yml workflow for the ${ecr} app repository ###
name: Stage Build and Deploy Fargate Container
on:
  workflow_dispatch:
  push:
    branches:
      - main
    paths-ignore:
      - '.github/**'

jobs:
  deploy:
    name: Stage Deploy Fargate Container
    uses: mitlibraries/.github/.github/workflows/fargate-shared-deploy-stage.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE: "${role}"
      ECR: "${ecr}"
