###
### Timdex related ECR's
### 

## oaiharvester
# oaiharvester ECR repo
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
# Outputs in dev
output "oaiharvester_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_oaiharvester.gha_role
    ecr      = module.ecr_oaiharvester.repository_name
    function = ""
    }
  )
  description = "Full contents of the dev-build.yml for the oaiharvester repo"
}
output "oaiharvester_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_oaiharvester.repository_name
    ecr_url  = module.ecr_oaiharvester.repository_url
    function = ""
    }
  )
  description = "Full contents of the Makefile for the oaiharvester repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "oaiharvester_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_oaiharvester.gha_role
    ecr      = module.ecr_oaiharvester.repository_name
    function = ""
    }
  )
  description = "Full contents of the stage-build.yml for the oaiharvester repo"
}

# Outputs after promotion to prod
output "oaiharvester_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_oaiharvester.repo_name}-gha-stage"
    role_prod  = "${module.ecr_oaiharvester.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_oaiharvester.repo_name}-stage"
    ecr_prod   = "${module.ecr_oaiharvester.repo_name}-prod"
    function   = ""
    }
  )
  description = "Full contents of the prod-promote.yml for the oaiharvester repo"
}


## transmogrifier 
# transmogrifier ECR repository
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
# Outputs in dev
output "transmogrifier_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_timdex_transmogrifier.gha_role
    ecr      = module.ecr_timdex_transmogrifier.repository_name
    function = ""
    }
  )
  description = "Full contents of the dev-build.yml for the transmogrifier repo"
}
output "transmogrifier_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_timdex_transmogrifier.repository_name
    ecr_url  = module.ecr_timdex_transmogrifier.repository_url
    function = ""
    }
  )
  description = "Full contents of the Makefile for the transmogrifier repo (allows devs to push to Dev account only)"
}
# Outputs in stage
output "transmogrifier_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_timdex_transmogrifier.gha_role
    ecr      = module.ecr_timdex_transmogrifier.repository_name
    function = ""
    }
  )
  description = "Full contents of the stage-build.yml for the transmogrifier repo"
}
# Outputs after promotion to prod
output "transmogrifier_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_timdex_transmogrifier.repo_name}-gha-stage"
    role_prod  = "${module.ecr_timdex_transmogrifier.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_timdex_transmogrifier.repo_name}-stage"
    ecr_prod   = "${module.ecr_timdex_transmogrifier.repo_name}-prod"
    function   = ""
    }
  )
  description = "Full contents of the prod-promote.yml for the transmogrifier repo"
}


## timdex-pipeline-lambdas
# Since this is a Lambda function, we need to set the function name now in order to build the correct files.
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
# Outputs in dev
output "timdex_lambdas_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_timdex_lambdas.gha_role
    ecr      = module.ecr_timdex_lambdas.repository_name
    function = local.ecr_timdex_lambdas_function_name
    }
  )
  description = "Full contents of the dev-build.yml for the timdex-pipeline-lambdas repo"
}
output "timdex_lambdas_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_timdex_lambdas.repository_name
    ecr_url  = module.ecr_timdex_lambdas.repository_url
    function = local.ecr_timdex_lambdas_function_name
    }
  )
  description = "Full contents of the Makefile for the timdex-pipeline-lambdas repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "timdex_lambdas_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_timdex_lambdas.gha_role
    ecr      = module.ecr_timdex_lambdas.repository_name
    function = local.ecr_timdex_lambdas_function_name
    }
  )
  description = "Full contents of the stage-build.yml for the timdex-pipeline-lambdas repo"
}

# Outputs after promotion to prod
output "timdex_lambdas_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_timdex_lambdas.repo_name}-gha-stage"
    role_prod  = "${module.ecr_timdex_lambdas.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_timdex_lambdas.repo_name}-stage"
    ecr_prod   = "${module.ecr_timdex_lambdas.repo_name}-prod"
    function   = local.ecr_timdex_lambdas_function_name
    }
  )
  description = "Full contents of the prod-promote.yml for the timdex-pipeline-lambdas repo"
}


## timdex-index-manager 
# timdex-index-manager ECR repository
module "ecr_timdex_tim" {
  source            = "./modules/ecr"
  repo_name         = "timdex-index-manager"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "timdex-infrastructure-timdex-index-manager"
  }
}
# Outputs in dev
output "tim_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_timdex_tim.gha_role
    ecr      = module.ecr_timdex_tim.repository_name
    function = ""
    }
  )
  description = "Full contents of the dev-build.yml for the timdex-index-manager repo"
}
output "tim_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_timdex_tim.repository_name
    ecr_url  = module.ecr_timdex_tim.repository_url
    function = ""
    }
  )
  description = "Full contents of the Makefile for the timdex-index-manager repo (allows devs to push to Dev account only)"
}
# Outputs in stage
output "tim_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_timdex_tim.gha_role
    ecr      = module.ecr_timdex_tim.repository_name
    function = ""
    }
  )
  description = "Full contents of the stage-build.yml for the timdex-index-manager repo"
}
# Outputs after promotion to prod
output "tim_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_timdex_tim.repo_name}-gha-stage"
    role_prod  = "${module.ecr_timdex_tim.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_timdex_tim.repo_name}-stage"
    ecr_prod   = "${module.ecr_timdex_tim.repo_name}-prod"
    function   = ""
    }
  )
  description = "Full contents of the prod-promote.yml for the timdex-index-manager repo"
}


## browsertrix-harvester
# browsertrix-harvester ECR repository
module "ecr_timdex_broswertrix" {
  source            = "./modules/ecr"
  repo_name         = "browsertrix-harvester"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "timdex-infrastructure-browsertrix"
  }
}
# Outputs in dev
output "broswertrix_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/dev-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_timdex_broswertrix.gha_role
    ecr      = module.ecr_timdex_broswertrix.repository_name
    function = ""
    }
  )
  description = "Full contents of the dev-build.yml for the browsertrix-harvester repo"
}
output "broswertrix_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/makefile.tpl", {
    ecr_name = module.ecr_timdex_broswertrix.repository_name
    ecr_url  = module.ecr_timdex_broswertrix.repository_url
    function = ""
    }
  )
  description = "Full contents of the Makefile for the browsertrix-harvester repo (allows devs to push to Dev account only)"
}
# Outputs in stage
output "broswertrix_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/stage-build.tpl", {
    region   = var.aws_region
    role     = module.ecr_timdex_broswertrix.gha_role
    ecr      = module.ecr_timdex_broswertrix.repository_name
    function = ""
    }
  )
  description = "Full contents of the stage-build.yml for the browsertrix-harvester repo"
}
# Outputs after promotion to prod
output "broswertrix_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_timdex_broswertrix.repo_name}-gha-stage"
    role_prod  = "${module.ecr_timdex_broswertrix.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_timdex_broswertrix.repo_name}-stage"
    ecr_prod   = "${module.ecr_timdex_broswertrix.repo_name}-prod"
    function   = ""
    }
  )
  description = "Full contents of the prod-promote.yml for the browsertrix-harvester repo"
}
