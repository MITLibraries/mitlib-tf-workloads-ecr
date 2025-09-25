### This is the Terraform-generated extra workflow job for the             ###
### ${ecr} app repository.                                                 ###
### This should be added to jobs section of the dev-build.yml. If this is  ### 
### a Lambda function, uncomment the FUNCTION: line                        ###

  deploy-${region}:
    needs: prep
    name: Dev Deploy ${region}
    uses: mitlibraries/.github/.github/workflows/ecr-multi-arch-deploy-dev.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE: "${role}"
      ECR: "${ecr}"
      CPU_ARCH: $${{ needs.prep.outputs.cpuarch }}
      # FUNCTION: "${function}"
      # PREBUILD: 
