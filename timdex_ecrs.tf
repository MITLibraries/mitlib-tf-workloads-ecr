
## Timdex related ECR's
# mario
module "ecr_mario" {
  source            = "./modules/ecr"
  repo_name         = "mario"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "timdex-infrastructure-mario"
  }
}
# oaiharvester
module "ecr_oaiharvester" {
  source            = "./modules/ecr"
  repo_name         = "oai-pmh-harvester"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "timdex-infrastructure-oaiharvester"
  }
}

# transmogrifier 
module "ecr_timdex_transmogrifier" {
  source            = "./modules/ecr"
  repo_name         = "transmogrifier"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "timdex-infrastructure-transmogrifier"
  }
}

# timdex-pipeline-lambdas
# Since this is a Lambda function, we need to set the function name now
# in order to build the correct files.
locals {
  ecr_timdex_lambdas_function_name = "timdex-format-${var.environment}"
}
module "ecr_timdex_lambdas" {
  source            = "./modules/ecr"
  repo_name         = "timdex-pipeline-lambdas"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "timdex-infrastructure-pipeline-lambdas"
  }
}

## For timdex-pipeline-lambdas application repo and ECR repository
# Outputs in dev
output "timdex_lambdas_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/lambda-dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_timdex_lambdas.gha_role
    ecr      = module.ecr_timdex_lambdas.repository_name
    function = local.ecr_timdex_lambdas_function_name
    }
  )
  description = "Full contents of the dev-build.yml for the ppod repo"
}
output "timdex_lambdas_lambdas_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/lambda-makefile.tpl", {
    ecr_name = module.ecr_timdex_lambdas.repository_name
    ecr_url  = module.ecr_timdex_lambdas.repository_url
    function = local.ecr_timdex_lambdas_function_name
    }
  )
  description = "Full contents of the Makefile for the ppod repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "timdex_lambdas_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/lambda-stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_timdex_lambdas.gha_role
    ecr      = module.ecr_timdex_lambdas.repository_name
    function = local.ecr_timdex_lambdas_function_name
    }
  )
  description = "Full contents of the stage-build.yml for the ppod repo"
}

# Outputs after promotion to prod
output "timdex_lambdas_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/lambda-prod-promote.tpl", {
    region   = var.aws_region
    region   = var.aws_region
    role     = module.ecr_timdex_lambdas.gha_role
    ecr      = module.ecr_timdex_lambdas.repository_name
    function = local.ecr_timdex_lambdas_function_name
    }
  )
  description = "Full contents of the prod-promote.yml for the ppod repo"
}
