### This is the Terraform-generated extra workflow job for the             ###
### ${ecr} app repository.                                                 ###
### This should be added to jobs section of the dev-build.yml. If this is  ### 
### a Lambda function, uncomment the FUNCTION: line                        ###

  build-push-${region}:
    name: Dev Build and Push ${region}
    uses: mitlibraries/.github/.github/workflows/ecr-multi-arch-deploy-dev.yml@main
    secrets: inherit
    with:
      AWS_REGION: "${region}"
      GHA_ROLE: "${role}"
      ECR: "${ecr}"
      # DOCKERFILE: # only if the name of the Dockerfile is not "Dockerfile"!
      # FUNCTION: "${function}"
      # PREBUILD: 
