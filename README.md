# Centralized ECR Repository Creation

This repo builds the ECR (Elastic Container Registry) repositories for containers. Most of the heavy lifting is in an embedded module [modules/ecr/main.tf](./modules/ecr/main.tf).

**The login policy can be shared between each app, since it's the same no matter what.**

## Dependencies

The only dependency is the ARN of the OpenID Connect Provider (placed in Parameter Store by the [mitlib-tf-workloads-init](https://github.com/MITLibraries/mitlib-tf-workloads-init) repo).

## Usage

There is a tight relationship between ECR repositories created here and the associated application repositories in GitHub due to the use of OIDC in the GitHub Actions in those application repositories. Make sure to coordinate any new ECR repositories with the developers building the applications that will be published there.

The "app-repo" tag should correspond with the name of the repo that contains the code that is compiled and saved in the ECR, or a combination of infrastructure and app repo names if multiple ECR's are needed in the same infrastructure project.

For each new ECR repository (or linked collection of ECR repositories), create a new `..._ecr.tf` file that contains

* at least one module call to the embedded `ecr` module to actually create the ECR
* at least one set of four outputs (four outputs per ECR)
  * a Makefile
  * a dev_build caller workflow
  * a stage_build caller workflow
  * a prod_promote caller workflow

The [ppod_ecr.tf](./ppod_ecr.tf) is a good example of a single ECR repository for a Lambda function build around a containerized app. The [timdex_ecrs.tf](./timdex_ecrs.tf) is a good example of a collection of ECR repositories all linked to one project (and there are both Fargate-linked ECRs and Lambda-linked ECRs in that file).

**Note**: For Lambda function ECRs, it is imperative that the Infra engineer coordinates with the software engineer to determine the name of the Lambda function as part of the creation of the ECR by this repository.

## For Application Developers

A quick note for application developers and the integration of workflows to automate the deployment of their containerized application to either Fargate or Lambda. When this code is deployed in Terraform Cloud, it generates outputs that contain the caller workflows code as well as the `Makefile` code for their application. Those outputs are accessible to the developers via Terraform Cloud -- they can go into TfC, find the correct Terraform Output, and then copy that text into their application repository.

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
| ecr\_dss | ./modules/ecr | n/a |
| ecr\_mario | ./modules/ecr | n/a |
| ecr\_matomo | ./modules/ecr | n/a |
| ecr\_oaiharvester | ./modules/ecr | n/a |
| ecr\_ppod | ./modules/ecr | n/a |
| ecr\_timdex\_lambdas | ./modules/ecr | n/a |
| ecr\_timdex\_tim | ./modules/ecr | n/a |
| ecr\_timdex\_transmogrifier | ./modules/ecr | n/a |
| ecr\_wcd2reshare | ./modules/ecr | n/a |
| ecr\_wiley | ./modules/ecr | n/a |

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

| Name | Description |
|------|-------------|
| alma\_webhook\_lambdas\_dev\_build\_workflow | Full contents of the dev-build.yml for the alma-webhook-lambdas repo |
| alma\_webhook\_lambdas\_makefile | Full contents of the Makefile for the alma-webhook-lambdas repo (allows devs to push to Dev account only) |
| alma\_webhook\_lambdas\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the alma-webhook-lambdas repo |
| alma\_webhook\_lambdas\_stage\_build\_workflow | Full contents of the stage-build.yml for the alma-webhook-lambdas repo |
| dss\_fargate\_dev\_build\_workflow | Full contents of the dev-build.yml for the dss repo |
| dss\_fargate\_makefile | Full contents of the Makefile for the dss repo (allows devs to push to Dev account only) |
| dss\_fargate\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the dss repo |
| dss\_fargate\_stage\_build\_workflow | Full contents of the stage-build.yml for the dss repo |
| mario\_dev\_build\_workflow | Full contents of the dev-build.yml for the mario repo |
| mario\_makefile | Full contents of the Makefile for the mario repo (allows devs to push to Dev account only) |
| mario\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the mario repo |
| mario\_stage\_build\_workflow | Full contents of the stage-build.yml for the mario repo |
| matomo\_fargate\_dev\_build\_workflow | Full contents of the dev-build.yml for the matomo repo |
| matomo\_fargate\_makefile | Full contents of the Makefile for the matomo repo (allows devs to push to Dev account only) |
| matomo\_fargate\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the matomo repo |
| matomo\_fargate\_stage\_build\_workflow | Full contents of the stage-build.yml for the matomo repo |
| oaiharvester\_dev\_build\_workflow | Full contents of the dev-build.yml for the oaiharvester repo |
| oaiharvester\_makefile | Full contents of the Makefile for the oaiharvester repo (allows devs to push to Dev account only) |
| oaiharvester\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the oaiharvester repo |
| oaiharvester\_stage\_build\_workflow | Full contents of the stage-build.yml for the oaiharvester repo |
| ppod\_dev\_build\_workflow | Full contents of the dev-build.yml for the ppod repo |
| ppod\_makefile | Full contents of the Makefile for the ppod repo (allows devs to push to Dev account only) |
| ppod\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the ppod repo |
| ppod\_stage\_build\_workflow | Full contents of the stage-build.yml for the ppod repo |
| tim\_dev\_build\_workflow | Full contents of the dev-build.yml for the timdex-index-manager repo |
| tim\_makefile | Full contents of the Makefile for the timdex-index-manager repo (allows devs to push to Dev account only) |
| tim\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the timdex-index-manager repo |
| tim\_stage\_build\_workflow | Full contents of the stage-build.yml for the timdex-index-manager repo |
| timdex\_lambdas\_dev\_build\_workflow | Full contents of the dev-build.yml for the timdex-pipeline-lambdas repo |
| timdex\_lambdas\_makefile | Full contents of the Makefile for the timdex-pipeline-lambdas repo (allows devs to push to Dev account only) |
| timdex\_lambdas\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the timdex-pipeline-lambdas repo |
| timdex\_lambdas\_stage\_build\_workflow | Full contents of the stage-build.yml for the timdex-pipeline-lambdas repo |
| transmogrifier\_dev\_build\_workflow | Full contents of the dev-build.yml for the transmogrifier repo |
| transmogrifier\_makefile | Full contents of the Makefile for the transmogrifier repo (allows devs to push to Dev account only) |
| transmogrifier\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the transmogrifier repo |
| transmogrifier\_stage\_build\_workflow | Full contents of the stage-build.yml for the transmogrifier repo |
| wcd2reshare\_dev\_build\_workflow | Full contents of the dev-build.yml for the wcd2reshare repo |
| wcd2reshare\_makefile | Full contents of the Makefile for the wcd2reshare repo (allows devs to push to Dev account only) |
| wcd2reshare\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the wcd2reshare repo |
| wcd2reshare\_stage\_build\_workflow | Full contents of the stage-build.yml for the wcd2reshare repo |
| wiley\_fargate\_dev\_build\_workflow | Full contents of the dev-build.yml for the wiley-deposits repo |
| wiley\_fargate\_makefile | Full contents of the Makefile for the wiley-deposits repo (allows devs to push to Dev account only) |
| wiley\_fargate\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the wiley-deposits repo |
| wiley\_fargate\_stage\_build\_workflow | Full contents of the stage-build.yml for the wiley-deposits repo |
<!-- END_TF_DOCS -->
