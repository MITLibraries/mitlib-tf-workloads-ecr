################################################################################
# This is used to simplify the SSM Parameter inputs
locals {
  vpc_vars  = "/tfvars/vpc"
  r53_vars  = "/tfvars/r53"
  init_vars = "/tfvars/init"
}

# OpenID Connect Identity Provider ARN
# Type:string datatype:test format:string
data "aws_ssm_parameter" "oidc_arn" {
  name = "${local.init_vars}/oidc-arn"
}