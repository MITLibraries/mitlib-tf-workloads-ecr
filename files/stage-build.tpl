### This is the Terraform-generated stage-build.yml workflow for the ${ecr} app repository ###
### If this is a Lambda repo, uncomment the FUNCTION line at the end of the document     ###
### If the container requires any additional pre-build commands, uncomment and edit      ###
### the PREBUILD line at the end of the document.                                        ###
name: Stage Container Build and Deploy
on:
  workflow_dispatch:
  push:
    branches:
      - main
    paths-ignore:
      - '.github/**'

jobs:
  deploy:
    name: Stage Container Deploy
    uses: mitlibraries/.github/.github/workflows/ecr-shared-deploy-stage.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE: "${role}"
      ECR: "${ecr}"
      # FUNCTION: "${function}"
      # PREBUILD: 
