# Module variables

# Information about the GitHub application repository
variable "repo_name" {
  description = "The name used for part of the ECR repo name - should be same as app repo name"
  type        = string
  # example = "alma-webhook-lambdas"
}

# Information about GitHub
variable "gh_organization" {
  description = "The name of the GitHub Organization."
  type        = string
  default     = "MITLibraries"
}

# Shared information passed from main code
variable "environment" {
  description = "The environement (dev, stage, or prod)"
  type        = string
}

variable "oidc_arn" {
  description = "The ARN of the OIDC profile"
  type        = string
}

variable "login_policy_arn" {
  description = "The ARN of the shared ECR login policy"
  type        = string
}

variable "tfoutput_ssm_path" {
  description = "The Parameter Store output path loaded in the root module"
  type        = string
}


variable "tags" {
  description = "The additional app-repo name"
  type        = map(any)
}
