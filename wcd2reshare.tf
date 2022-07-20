
# wcd2reshare
# Since this is a Lambda function, we need to set the function name now
# in order to build the correct files.
locals {
  ecr_wcd2reshare_function_name = "wcd2reshare-${var.environment}"
}
module "ecr_wcd2reshare" {
  source            = "./modules/ecr"
  repo_name         = "wcd2reshare"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "wcd2reshare"
  }
}


## For wcd2reshare application repo and ECR repository
# Outputs in dev
output "wcd2reshare_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/lambda-dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_wcd2reshare.gha_role
    ecr      = module.ecr_wcd2reshare.repository_name
    function = local.ecr_wcd2reshare_function_name
    }
  )
  description = "Full contents of the dev-build.yml for the wcd2reshare repo"
}
output "wcd2reshare_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/lambda-makefile.tpl", {
    ecr_name = module.ecr_wcd2reshare.repository_name
    ecr_url  = module.ecr_wcd2reshare.repository_url
    function = local.ecr_wcd2reshare_function_name
    }
  )
  description = "Full contents of the Makefile for the wcd2reshare repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "wcd2reshare_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/lambda-stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_wcd2reshare.gha_role
    ecr      = module.ecr_wcd2reshare.repository_name
    function = local.ecr_wcd2reshare_function_name
    }
  )
  description = "Full contents of the stage-build.yml for the wcd2reshare repo"
}

# Outputs after promotion to prod
output "wcd2reshare_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/lambda-prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_wcd2reshare.repo_name}-gha-stage"
    role_prod  = "${module.ecr_wcd2reshare.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_wcd2reshare.repo_name}-stage"
    ecr_prod   = "${module.ecr_wcd2reshare.repo_name}-prod"
    function   = local.ecr_wcd2reshare_function_name
    }
  )
  description = "Full contents of the prod-promote.yml for the wcd2reshare repo"
}
