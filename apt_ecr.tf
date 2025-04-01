# Archival Packaging Tool (apt) containers
# A standard ECR for an ECS Fargate task

locals {
  ecr_apt = "archival-packaging-tool-${var.environment}"
}

module "ecr_apt" {
  source            = "./modules/ecr"
  repo_name         = "archival-packaging-tool"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "archival-packaging-tool"
  }
}

## Outputs to Terraform Cloud for devs ##

## For archival-packaging-tool application repo and ECR repository
# Outputs in dev
output "apt_fargate_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_apt.gha_role
    ecr      = module.ecr_apt.repository_name
    function = ""
    }
  )
  description = "Full contents of the dev-build.yml for the archival-packaging-tool repo"
}
output "apt_fargate_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_apt.repository_name
    ecr_url  = module.ecr_apt.repository_url
    function = ""
    }
  )
  description = "Full contents of the Makefile for the archival-packaging-tool repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "apt_fargate_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_apt.gha_role
    ecr      = module.ecr_apt.repository_name
    function = ""
    }
  )
  description = "Full contents of the stage-build.yml for the archival-packaging-tool repo"
}

# Outputs after promotion to prod
output "apt_fargate_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_apt.repo_name}-gha-stage"
    role_prod  = "${module.ecr_apt.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_apt.repo_name}-stage"
    ecr_prod   = "${module.ecr_apt.repo_name}-prod"
    function   = ""
    }
  )
  description = "Full contents of the prod-promote.yml for the archival-packaging-tool repo"
}
