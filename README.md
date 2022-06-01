# Centralized ECR Repository Creation

This repo builds the ECR (Elastic Container Registry) repositories for containers. Most of the heavy lifting is in an embedded module [modules/ecr/main.tf](./modules/ecr/main.tf). The [ecr_repos.tf](./ecr_repos.tf) file should have one module call per containerized app.

**The login policy can be shared between each app, since it's the same no matter what.**

## Dependencies

The only dependency is the ARN of the OpenID Connect Provider (placed in Parameter Store by the [mitlib-tf-workloads-init](https://github.com/MITLibraries/mitlib-tf-workloads-init) repo).

## Usage

There is a tight relationship between ECR repositories created here and the associated application repositories in GitHub due to the use of OIDC in the GitHub Actions in those application repositories. Make sure to coordinate any new ECR repositories with the developers building the applications that will be published there.

The "app-repo" tag should correspond with the name of the repo that contains the code that is compiled and saved in the ECR, or a combination of infrastructure and app repo names if multiple ECR's are needed in the same infrastructure project.


## TF markdown is automatically inserted at the bottom of this file, nothing should be written beyond this point

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.1 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.75.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| ecr\_alma\_webhook\_lambdas | ./modules/ecr | n/a |
| ecr\_mario | ./modules/ecr | n/a |
| ecr\_oaiharvester | ./modules/ecr | n/a |
| ecr\_ppod | ./modules/ecr | n/a |
| ecr\_timdex\_lambdas | ./modules/ecr | n/a |
| ecr\_timdex\_transmogrifier | ./modules/ecr | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.login](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_document.login](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.oidc_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| appinput\_ssm\_path | Standard prefix in Parameter Store for Terraform outputs specifically needed by <app-name> | `string` | n/a | yes |
| aws\_region | The AWS region where this infrastructure will be deployed. | `string` | `"us-east-1"` | no |
| environment | The name of the environment/stage/workspace (e.g., `stage`, `prod`, `dev`) | `string` | n/a | yes |
| mitlib | The shortname name of our MITLibraries Organization | `string` | `"mitlib"` | no |
| name | The name of the app/resource this code builds | `string` | n/a | yes |
| ou | The name of the AWS OU that contains the AWS Accounts that are managed by this code. | `string` | n/a | yes |
| tfinput\_ssm\_path | Standard prefix in Parameter Store for inputs to Terraform for initial infrastructure builds | `string` | n/a | yes |
| tfoutput\_ssm\_path | Standard prefix in Parameter Store for generic Terraform outputs (typically needed by other infra code) | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
