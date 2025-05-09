##############################################################################
# s3-bagit-validator for the CDPS project in the us-west-2 region
# We use the same locals block as the _default

module "ecr_cdps_s3_bagit_validator_west" {
  source = "./modules/ecr"
  providers = {
    aws = aws.west-2
  }
  repo_name         = "s3-bagit-validator"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "s3-bagit-validator"
  }
}

## For s3-bagit-validator application repo and ECR repository in us-west-2
# Outputs in dev
output "s3_bagit_validator_dev_build_workflow_west" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build-extra-region.tpl", {
    region   = "us-west-2"
    role     = module.ecr_cdps_s3_bagit_validator.gha_role
    ecr      = module.ecr_cdps_s3_bagit_validator_west.repository_name
    function = local.ecr_cdps_s3_bagit_validator_function_name
    }
  )
  description = "Additional job for the dev-build.yml for the s3-bagit-validator repo to deploy in us-west-2"
}

output "s3_bagit_validator_makefile_west" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile-extra-region.tpl", {
    region   = "us-west-2"
    ecr_name = module.ecr_cdps_s3_bagit_validator_west.repository_name
    ecr_url  = module.ecr_cdps_s3_bagit_validator_west.repository_url
    function = local.ecr_cdps_s3_bagit_validator_function_name
    }
  )
  description = "Full contents of the Makefile for the s3-bagit-validator repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "s3_bagit_validator_stage_build_workflow_west" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = "us-west-2"
    role     = module.ecr_cdps_s3_bagit_validator.gha_role
    ecr      = module.ecr_cdps_s3_bagit_validator_west.repository_name
    function = local.ecr_cdps_s3_bagit_validator_function_name
    }
  )
  description = "Additional job for the stage-build.yml for the s3-bagit-validator repo to deploy in us-west-2"
}

# Outputs after promotion to prod
output "s3_bagit_validator_prod_promote_workflow_west" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = "us-west-2"
    role_stage = "${module.ecr_cdps_s3_bagit_validator_west.repo_name}-gha-stage"
    role_prod  = "${module.ecr_cdps_s3_bagit_validator_west.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_cdps_s3_bagit_validator_west.repo_name}-stage"
    ecr_prod   = "${module.ecr_cdps_s3_bagit_validator_west.repo_name}-prod"
    function   = local.ecr_cdps_s3_bagit_validator_function_name
    }
  )
  description = "Additional job for the prod-promote.yml for the s3-bagit-validator repo to deploy in us-west-2"
}
