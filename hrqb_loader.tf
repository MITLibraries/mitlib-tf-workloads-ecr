
# hrqb_client containers
# This is a standard ECR for an ECS with a Fargate launch type
locals {
  ecr_hrqb_client = "hrqb-client-${var.environment}"
}
module "ecr_hrqb_client" {
  source            = "./modules/ecr"
  repo_name         = "hrqb-client"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "hrqb-client"
  }
}

## Outputs to Terraform Cloud for devs ##

## For hrqb_client application repo and ECR repository
# Outputs in dev
output "hrqb_client_fargate_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_hrqb_client.gha_role
    ecr      = module.ecr_hrqb_client.repository_name
    function = ""
    }
  )
  description = "Full contents of the dev-build.yml for the hrqb-client repo"
}
output "hrqb_client_fargate_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_hrqb_client.repository_name
    ecr_url  = module.ecr_hrqb_client.repository_url
    function = ""
    }
  )
  description = "Full contents of the Makefile for the hrqb-client repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "hrqb_client_fargate_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_hrqb_client.gha_role
    ecr      = module.ecr_hrqb_client.repository_name
    function = ""
    }
  )
  description = "Full contents of the stage-build.yml for the hrqb-client repo"
}

# Outputs after promotion to prod
output "hrqb_client_fargate_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_hrqb_client.repo_name}-gha-stage"
    role_prod  = "${module.ecr_hrqb_client.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_hrqb_client.repo_name}-stage"
    ecr_prod   = "${module.ecr_hrqb_client.repo_name}-prod"
    function   = ""
    }
  )
  description = "Full contents of the prod-promote.yml for the hrqb-client repo"
}
