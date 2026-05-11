### This should be added to jobs section of the prod-promote.yml.
### If this is a Lambda function, uncomment the FUNCTION: line

  promote-${region}:
    name: Prod promote ${region}
    uses: mitlibraries/.github/.github/workflows/ecr-multi-arch-promote-prod.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE_STAGE: ${role_stage}
      GHA_ROLE_PROD: ${role_prod}
      ECR_STAGE: "${ecr_stage}"
      ECR_PROD: "${ecr_prod}"
      # DEFAULT_BRANCH: # Only if the default branch is not "main"!
      # FUNCTION: "${function}"
 