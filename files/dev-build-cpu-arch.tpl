### This is the Terraform-generated dev-build.yml workflow for the         ### 
### ${ecr} app repository.                                                 ###
### If this is a Lambda repo, uncomment the FUNCTION line at the end of    ### 
### the document. If the container requires any additional pre-build       ### 
### commands, uncomment and edit the PREBUILD line at the end of the       ###
### document.                                                              ###

name: Dev Container Build and Deploy
on:
  workflow_dispatch:
  pull_request:
    branches:
      - main
    paths-ignore:
      - '.github/**'

permissions:
  id-token: write
  contents: read

jobs:
  build-push:
    name: Dev Build and Push
    uses: mitlibraries/.github/.github/workflows/ecr-multi-arch-deploy-dev.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE: "${role}"
      ECR: "${ecr}"
      # DOCKERFILE: # only if the name of the Dockerfile is not "Dockerfile"!
      # FUNCTION: "${function}"
      # PREBUILD: 
