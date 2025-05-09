# Embedded ECR Creation Module

Creates the ECR Repository and all the necessary infrastructure glue around it.

## What is created

The following resources are generated when this module is called

* an ECR repository with a lifecycle policy to only store the five (5) most recent containers
* an IAM Policy providing read/write access to the ECR Repository
* a trust policy for OIDC connections from GitHub Actions that is tightly coupled to the GitHub repository name
* an IAM Role for GitHub Actions OIDC connections to AWS

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.11 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 5.62.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_policy.rw_this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.gha_this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.gha_ecr_login](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.gha_ecr_rw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_ssm_parameter.ecr_repository_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.ecr_repository_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.gha_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.gh_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.rw_this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | The environment (dev, stage, or prod) | `string` | n/a | yes |
| gh\_organization | The name of the GitHub Organization. | `string` | `"MITLibraries"` | no |
| login\_policy\_arn | The ARN of the shared ECR login policy | `string` | n/a | yes |
| oidc\_arn | The ARN of the OIDC profile | `string` | n/a | yes |
| repo\_name | The name used for part of the ECR repo name - should be same as app repo name | `string` | n/a | yes |
| tags | The additional app-repo name | `map(any)` | n/a | yes |
| tfoutput\_ssm\_path | The Parameter Store output path loaded in the root module | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gha\_role | Github action role used to update the ECR repository |
| repo\_name | The repo\_name that was passed in to the module for naming purposes |
| repository\_name | The name of the ECR repository |
| repository\_url | The URL of the ECR repository |
<!-- END_TF_DOCS -->