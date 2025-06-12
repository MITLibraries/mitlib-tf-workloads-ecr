# Tacos Detectors (tacos-detectors-lambdas) containers
# A standard ECR for an ECS Fargate task

locals {
  ecr_tacos_detectors = "tacos-detectors-lambdas-${var.environment}"
}

module "ecr_tacos_detectors" {
  source            = "./modules/ecr"
  repo_name         = "tacos-detectors-lambdas"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "tacos-detectors-lambdas"
  }
}

## Outputs to Terraform Cloud for devs ##

## For tacos-detectors-lambdas application repo and ECR repository
# Outputs in dev
output "tacos_detectors_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_tacos_detectors.gha_role
    ecr      = module.ecr_tacos_detectors.repository_name
    function = local.ecr_tacos_detectors
    }
  )
  description = "Full contents of the dev-build.yml for the tacos-detectors-lambdas repo"
}
output "tacos_detectors_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_tacos_detectors.repository_name
    ecr_url  = module.ecr_tacos_detectors.repository_url
    function = local.ecr_tacos_detectors
    }
  )
  description = "Full contents of the Makefile for the tacos-detectors-lambdas repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "tacos_detectors_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_tacos_detectors.gha_role
    ecr      = module.ecr_tacos_detectors.repository_name
    function = local.ecr_tacos_detectors
    }
  )
  description = "Full contents of the stage-build.yml for the tacos-detectors-lambdas repo"
}

# Outputs after promotion to prod
output "tacos_detectors_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_tacos_detectors.repo_name}-gha-stage"
    role_prod  = "${module.ecr_tacos_detectors.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_tacos_detectors.repo_name}-stage"
    ecr_prod   = "${module.ecr_tacos_detectors.repo_name}-prod"
    function   = local.ecr_tacos_detectors
    }
  )
  description = "Full contents of the prod-promote.yml for the tacos-detectors-lambdas repo"
}
