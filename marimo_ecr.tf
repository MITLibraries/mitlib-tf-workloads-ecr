
# marimo-launcher containers
# This is a standard ECR for an ECS with a Fargate launch type
locals {
  ecr_marimo = "marimo-${var.environment}"
}
module "ecr_marimo" {
  source            = "./modules/ecr"
  repo_name         = "marimo-launcher"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "marimo-launcher"
  }
}

## Outputs to Terraform Cloud for devs ##

## For marimo-launcher application repo and ECR repository
# Outputs in dev
output "marimo_fargate_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build-cpu-arch.tpl", {
    region   = var.aws_region
    role     = module.ecr_marimo.gha_role
    ecr      = module.ecr_marimo.repository_name
    function = ""
    }
  )
  description = "Full contents of the dev-build.yml for the marimo-launcher repo"
}
output "marimo_fargate_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile-cpu-arch.tpl", {
    ecr_name = module.ecr_marimo.repository_name
    ecr_url  = module.ecr_marimo.repository_url
    function = ""
    }
  )
  description = "Full contents of the Makefile for the marimo-launcher repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "marimo_fargate_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build-cpu-arch.tpl", {
    region   = var.aws_region
    role     = module.ecr_marimo.gha_role
    ecr      = module.ecr_marimo.repository_name
    function = ""
    }
  )
  description = "Full contents of the stage-build.yml for the marimo-launcher repo"
}

# Outputs after promotion to prod
output "marimo_fargate_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote-cpu-arch.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_marimo.repo_name}-gha-stage"
    role_prod  = "${module.ecr_marimo.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_marimo.repo_name}-stage"
    ecr_prod   = "${module.ecr_marimo.repo_name}-prod"
    function   = ""
    }
  )
  description = "Full contents of the prod-promote.yml for the marimo-launcher repo"
}
