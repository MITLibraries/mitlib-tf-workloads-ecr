# Module variables

# Information about the GitHub application repository
variable "repo_name" {
  description = "The name used for part of the ECR repo name - should be same as app repo name"
  type        = string
  # example = "alma-webhook-lambdas"
}

## Information about GitHub
variable "gh_organization" {
  description = "The name of the GitHub Organization."
  type        = string
  default     = "MITLibraries"
}

## Shared information passed from main code (since modules do not inherit variables/values from the root)
# The environment (pulled by the root module from TfC variables)
variable "environment" {
  description = "The environement (dev, stage, or prod)"
  type        = string
}

# The OIDC IDP ARN (pulled by the root module from Parameter Store)
variable "oidc_arn" {
  description = "The ARN of the OIDC profile"
  type        = string
}

# The shared policy allowing login to ECR (generated in the root module)
variable "login_policy_arn" {
  description = "The ARN of the shared ECR login policy"
  type        = string
}

# The param store output path (pulled by the root module from TfC variables)
variable "tfoutput_ssm_path" {
  description = "The Parameter Store output path loaded in the root module"
  type        = string
}

# Any additional tags passed from the root (which at least includes the name of the app repo)
variable "tags" {
  description = "The additional app-repo name"
  type        = map(any)
}
