### This should be added to jobs section of the dev-build.yml.
### If this is a Lambda function, uncomment the FUNCTION: line

  deploy-${region}:
    name: Prod Container Promote ${region}
    uses: mitlibraries/.github/.github/workflows/ecr-shared-promote-prod.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE_STAGE: ${role_stage}
      GHA_ROLE_PROD: ${role_prod}
      ECR_STAGE: "${ecr_stage}"
      ECR_PROD: "${ecr_prod}"
      # FUNCTION: "${function}"
 