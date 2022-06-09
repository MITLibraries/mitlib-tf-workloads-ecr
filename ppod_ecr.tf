
# ppod
# Since this is a Lambda function, we need to set the function name now
# in order to build the correct files.
locals {
  ecr_ppod_function_name = "ppod-${var.environment}"
}
module "ecr_ppod" {
  source            = "./modules/ecr"
  repo_name         = "ppod"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "ppod"
  }
}


## For ppod application repo and ECR repository
# Outputs in dev
output "ppod_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/lambda-dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_ppod.gha_role
    ecr      = module.ecr_ppod.repository_name
    function = local.ecr_ppod_function_name
    }
  )
  description = "Full contents of the dev-build.yml for the ppod repo"
}
output "ppod_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/lambda-makefile.tpl", {
    ecr_name = module.ecr_ppod.repository_name
    ecr_url  = module.ecr_ppod.repository_url
    function = local.ecr_ppod_function_name
    }
  )
  description = "Full contents of the Makefile for the ppod repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "ppod_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/lambda-stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_ppod.gha_role
    ecr      = module.ecr_ppod.repository_name
    function = local.ecr_ppod_function_name
    }
  )
  description = "Full contents of the stage-build.yml for the ppod repo"
}

# Outputs after promotion to prod
output "ppod_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/lambda-prod-promote.tpl", {
    region   = var.aws_region
    region   = var.aws_region
    role     = module.ecr_ppod.gha_role
    ecr      = module.ecr_ppod.repository_name
    function = local.ecr_ppod_function_name
    }
  )
  description = "Full contents of the prod-promote.yml for the ppod repo"
}
