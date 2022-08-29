
# wiley containers
# This is a standard ECR for an ECS with a Fargate launch type
locals {
  ecr_wiley = "wiley-${var.environment}"
}
module "ecr_wiley" {
  source            = "./modules/ecr"
  repo_name         = "wiley-deposits"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "wiley-deposits"
  }
}

## Outputs to Terraform Cloud for devs ##

## For wiley application repo and ECR repository
# Outputs in dev
output "wiley_fargate_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/fargate-dev-build.tpl", {
    region = var.aws_region
    role   = module.ecr_wiley.gha_role
    ecr    = module.ecr_wiley.repository_name
    }
  )
  description = "Full contents of the dev-build.yml for the wiley-deposits repo"
}
output "wiley_fargate_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/fargate-makefile.tpl", {
    ecr_name = module.ecr_wiley.repository_name
    ecr_url  = module.ecr_wiley.repository_url
    }
  )
  description = "Full contents of the Makefile for the wiley-deposits repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "wiley_fargate_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/fargate-stage-build.tpl", {
    region = var.aws_region
    role   = module.ecr_wiley.gha_role
    ecr    = module.ecr_wiley.repository_name
    }
  )
  description = "Full contents of the stage-build.yml for the wiley-deposits repo"
}

# Outputs after promotion to prod
output "wiley_fargate_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/fargate-prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_wiley.repo_name}-gha-stage"
    role_prod  = "${module.ecr_wiley.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_wiley.repo_name}-stage"
    ecr_prod   = "${module.ecr_wiley.repo_name}-prod"
    }
  )
  description = "Full contents of the prod-promote.yml for the wiley-deposits repo"
}
