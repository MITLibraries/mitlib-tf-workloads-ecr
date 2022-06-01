# alma-webhook-lambdas
module "ecr_alma_webhook_lambdas" {
  source            = "./modules/ecr"
  repo_name         = "alma-webhook-lambdas"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "alma-webhook-lambdas"
  }
}

# ppod
module "ecr_ppod" {
  source            = "./modules/ecr"
  repo_name         = "ppod"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "ppod"
  }
}

# Timdex related ECR's

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
# timdex-pipeline-lambdas
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
