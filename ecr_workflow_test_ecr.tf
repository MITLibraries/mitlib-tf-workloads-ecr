
# ecr-workflow-test containers
# This is a standard ECR for an ECS with a Fargate launch type
locals {
  ecr_workflowtest = "workflowtest-${var.environment}"
}
module "ecr_workflowtest" {
  source            = "./modules/ecr"
  repo_name         = "ecr-workflow-test"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "ecr-workflow-test"
  }
}


## Outputs to Terraform Cloud for devs ##

## For workflowtest application repo and ECR repository
# Outputs in dev
output "workflowtest_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build-cpu-arch.tpl", {
    region   = var.aws_region
    role     = module.ecr_workflowtest.gha_role
    ecr      = module.ecr_workflowtest.repository_name
    function = ""
    }
  )
  description = "Full contents of the dev-build.yml for the ecr-workflow-test repo"
}
output "workflowtest_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile-cpu-arch.tpl", {
    ecr_name = module.ecr_workflowtest.repository_name
    ecr_url  = module.ecr_workflowtest.repository_url
    function = ""
    }
  )
  description = "Full contents of the Makefile for the ecr-workflow-test repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "workflowtest_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build-cpu-arch.tpl", {
    region   = var.aws_region
    role     = module.ecr_workflowtest.gha_role
    ecr      = module.ecr_workflowtest.repository_name
    function = ""
    }
  )
  description = "Full contents of the stage-build.yml for the ecr-workflow-test repo"
}

# Outputs after promotion to prod
output "workflowtest_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote-cpu-arch.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_workflowtest.repo_name}-gha-stage"
    role_prod  = "${module.ecr_workflowtest.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_workflowtest.repo_name}-stage"
    ecr_prod   = "${module.ecr_workflowtest.repo_name}-prod"
    function   = ""
    }
  )
  description = "Full contents of the prod-promote.yml for the ecr-workflow-test repo"
}
