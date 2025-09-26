### This should be added to jobs section of the prod-promote.yml.
### If this is a Lambda function, uncomment the FUNCTION: line

  deploy-${region}:
    needs: prep
    name: Deploy ${region}
    uses: mitlibraries/.github/.github/workflows/ecr-multi-arch-promote-prod.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE_STAGE: ${role_stage}
      GHA_ROLE_PROD: ${role_prod}
      ECR_STAGE: "${ecr_stage}"
      ECR_PROD: "${ecr_prod}"
      CPU_ARCH: $${{ needs.prep.outputs.cpuarch }}
      # FUNCTION: "${function}"
 