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
