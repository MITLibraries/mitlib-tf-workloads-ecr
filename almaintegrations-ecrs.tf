###
### ECRs for the various Alma integrations
###

################################################################################
## patronload
module "ecr_patronload" {
  source            = "./modules/ecr"
  repo_name         = "alma-patronload"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "alma-patronload"
  }
}

# Outputs in dev
output "patronload_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_patronload.gha_role
    ecr      = module.ecr_patronload.repository_name
    function = ""
    }
  )
  description = "Full contents of the dev-build.yml for the alma-patronload repo"
}
output "patronload_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_patronload.repository_name
    ecr_url  = module.ecr_patronload.repository_url
    function = ""
    }
  )
  description = "Full contents of the Makefile for the alma-patronload repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "patronload_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_patronload.gha_role
    ecr      = module.ecr_patronload.repository_name
    function = ""
    }
  )
  description = "Full contents of the stage-build.yml for the alma-patronload repo"
}

# Outputs after promotion to prod
output "patronload_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_patronload.repo_name}-gha-stage"
    role_prod  = "${module.ecr_patronload.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_patronload.repo_name}-stage"
    ecr_prod   = "${module.ecr_patronload.repo_name}-prod"
    function   = ""
    }
  )
  description = "Full contents of the prod-promote.yml for the alma-patronload repo"
}

################################################################################
## creditcardslips
module "ecr_creditcardslips" {
  source            = "./modules/ecr"
  repo_name         = "alma-creditcardslips"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "alma-creditcardslips"
  }
}

# Outputs in dev
output "creditcardslips_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_creditcardslips.gha_role
    ecr      = module.ecr_creditcardslips.repository_name
    function = ""
    }
  )
  description = "Full contents of the dev-build.yml for the alma-creditcardslips repo"
}
output "creditcardslips_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_creditcardslips.repository_name
    ecr_url  = module.ecr_creditcardslips.repository_url
    function = ""
    }
  )
  description = "Full contents of the Makefile for the alma-creditcardslips repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "creditcardslips_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_creditcardslips.gha_role
    ecr      = module.ecr_creditcardslips.repository_name
    function = ""
    }
  )
  description = "Full contents of the stage-build.yml for the alma-creditcardslips repo"
}

# Outputs after promotion to prod
output "creditcardslips_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_creditcardslips.repo_name}-gha-stage"
    role_prod  = "${module.ecr_creditcardslips.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_creditcardslips.repo_name}-stage"
    ecr_prod   = "${module.ecr_creditcardslips.repo_name}-prod"
    function   = ""
    }
  )
  description = "Full contents of the prod-promote.yml for the alma-creditcardslips repo"
}


################################################################################
## sapinvoices
module "ecr_sapinvoices" {
  source            = "./modules/ecr"
  repo_name         = "alma-sapinvoices"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "alma-sapinvoices"
  }
}

# Outputs in dev
output "sapinvoices_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_sapinvoices.gha_role
    ecr      = module.ecr_sapinvoices.repository_name
    function = ""
    }
  )
  description = "Full contents of the dev-build.yml for the alma-sapinvoices repo"
}
output "sapinvoices_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_sapinvoices.repository_name
    ecr_url  = module.ecr_sapinvoices.repository_url
    function = ""
    }
  )
  description = "Full contents of the Makefile for the alma-sapinvoices repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "sapinvoices_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_sapinvoices.gha_role
    ecr      = module.ecr_sapinvoices.repository_name
    function = ""
    }
  )
  description = "Full contents of the stage-build.yml for the alma-sapinvoices repo"
}

# Outputs after promotion to prod
output "sapinvoices_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_sapinvoices.repo_name}-gha-stage"
    role_prod  = "${module.ecr_sapinvoices.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_sapinvoices.repo_name}-stage"
    ecr_prod   = "${module.ecr_sapinvoices.repo_name}-prod"
    function   = ""
    }
  )
  description = "Full contents of the prod-promote.yml for the alma-sapinvoices repo"
}
