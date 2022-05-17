# sample for testing module (should look the same as ppod)
module "ecr_kale" {
  source            = "./modules/ecr"
  repo_name         = "kale"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "kale"
  }
}

# sample for testing module (should look the same as ppod)
module "ecr_beans" {
  source            = "./modules/ecr"
  repo_name         = "beans"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo = "beans"
  }
}
