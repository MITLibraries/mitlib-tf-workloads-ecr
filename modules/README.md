# Modules README

There is just one module here that does all the work for creating the ECR repository and the associated policies and roles necessary for containerized apps to be published.

The outputs from the module are stored in Parameter Store in the standard parameter output path. Each module generates its own subdirectory of that path for the two variables.

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.1 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

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
| [aws_ssm_parameter.ecr_repository_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.gha_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_iam_policy_document.gh_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.rw_this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | The environement (dev, stage, or prod) | `string` | n/a | yes |
| gh\_organization | The name of the GitHub Organization. | `string` | `"MITLibraries"` | no |
| login\_policy\_arn | The ARN of the shared ECR login policy | `string` | n/a | yes |
| oidc\_arn | The ARN of the OIDC profile | `string` | n/a | yes |
| repo\_name | The name used for part of the ECR repo name - should be same as app repo name | `string` | n/a | yes |
| tags | The additional app-repo name | `map(any)` | n/a | yes |
| tfoutput\_ssm\_path | The Parameter Store output path loaded in the root module | `string` | n/a | yes |

## Outputs

No outputs.
