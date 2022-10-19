### This is the Terraform-generated prod-promote.yml workflow for the ${ecr} app repository. ###
### If this is a Lambda repo, uncomment the FUNCTION line at the end of the document         ###
name: Prod Container Promote
on:
  workflow_dispatch:
  release:
    types: [published]

jobs:
  deploy:
    name: Prod Container Promote
    uses: mitlibraries/.github/.github/workflows/ecr-shared-promote-prod.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE_STAGE: ${role_stage}
      GHA_ROLE_PROD: ${role_prod}
      ECR_STAGE: "${ecr_stage}"
      ECR_PROD: "${ecr_prod}"
      # FUNCTION: "${function}"
 