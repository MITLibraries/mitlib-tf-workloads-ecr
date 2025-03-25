## CDPS related ECRs

##############################################################################
# s3-bagit-validator for the CDPS project
# Since this is a Lambda function, we need to set the function name now in 
# order to build the correct files.
locals {
  ecr_cdps_s3_bagit_validator_function_name = "s3-bagit-validator-${var.environment}"
}

module "ecr_cdps_s3_bagit_validator" {
  source            = "./modules/ecr"
  repo_name         = "s3-bagit-validator"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "s3-bagit-validator"
  }
}

## For s3-bagit-validator application repo and ECR repository
# Outputs in dev
output "s3_bagit_validator_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_cdps_s3_bagit_validator.gha_role
    ecr      = module.ecr_cdps_s3_bagit_validator.repository_name
    function = local.ecr_cdps_s3_bagit_validator_function_name
    }
  )
  description = "Full contents of the dev-build.yml for the s3-bagit-validator repo"
}
output "s3_bagit_validator_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_cdps_s3_bagit_validator.repository_name
    ecr_url  = module.ecr_cdps_s3_bagit_validator.repository_url
    function = local.ecr_cdps_s3_bagit_validator_function_name
    }
  )
  description = "Full contents of the Makefile for the s3-bagit-validator repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "s3_bagit_validator_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_cdps_s3_bagit_validator.gha_role
    ecr      = module.ecr_cdps_s3_bagit_validator.repository_name
    function = local.ecr_cdps_s3_bagit_validator_function_name
    }
  )
  description = "Full contents of the stage-build.yml for the s3-bagit-validator repo"
}

# Outputs after promotion to prod
output "s3_bagit_validator_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_cdps_s3_bagit_validator.repo_name}-gha-stage"
    role_prod  = "${module.ecr_cdps_s3_bagit_validator.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_cdps_s3_bagit_validator.repo_name}-stage"
    ecr_prod   = "${module.ecr_cdps_s3_bagit_validator.repo_name}-prod"
    function   = local.ecr_cdps_s3_bagit_validator_function_name
    }
  )
  description = "Full contents of the prod-promote.yml for the s3-bagit-validator repo"
}


##############################################################################
# cdps-curt for the CDPS project
# This is a Fargate task, so no need for a Lambda function name

module "ecr_cdps_curt" {
  source            = "./modules/ecr"
  repo_name         = "cdps-curt"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "cdps-curt"
  }
}

## For cdps-curt application repo and ECR repository
# Outputs in dev
output "cdps_curt_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_cdps_curt.gha_role
    ecr      = module.ecr_cdps_curt.repository_name
    function = ""
    }
  )
  description = "Full contents of the dev-build.yml for the cdps-curt repo"
}
output "cdps_curt_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_cdps_curt.repository_name
    ecr_url  = module.ecr_cdps_curt.repository_url
    function = ""
    }
  )
  description = "Full contents of the Makefile for the cdps-curt repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "cdps_curt_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_cdps_curt.gha_role
    ecr      = module.ecr_cdps_curt.repository_name
    function = ""
    }
  )
  description = "Full contents of the stage-build.yml for the cdps-curt repo"
}

# Outputs after promotion to prod
output "cdps_curt_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_cdps_curt.repo_name}-gha-stage"
    role_prod  = "${module.ecr_cdps_curt.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_cdps_curt.repo_name}-stage"
    ecr_prod   = "${module.ecr_cdps_curt.repo_name}-prod"
    function   = ""
    }
  )
  description = "Full contents of the prod-promote.yml for the cdps-curt repo"
}
