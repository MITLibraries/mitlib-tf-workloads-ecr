### This should be added to jobs section of the stage-build.yml.
### If this is a Lambda function, uncomment the FUNCTION: line

  deploy-${region}:
    name: Stage Container Deploy ${region}
    uses: mitlibraries/.github/.github/workflows/ecr-shared-deploy-stage.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE: "${role}"
      ECR: "${ecr}"
      # FUNCTION: "${function}"
      # PREBUILD: 
