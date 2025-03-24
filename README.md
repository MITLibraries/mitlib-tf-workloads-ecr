# This is a public repo

# Centralized ECR Repository Creation

This repo builds the ECR (Elastic Container Registry) repositories for containers. Most of the heavy lifting is in an embedded module [modules/ecr/main.tf](./modules/ecr/main.tf).

**The login policy can be shared between each app, since it's the same no matter what.**

## Dependencies

The only dependency is the ARN of the OpenID Connect Provider (placed in Parameter Store by the [mitlib-tf-workloads-init](https://github.com/MITLibraries/mitlib-tf-workloads-init) repo).

### Pre-Commit Hooks

For proper linting and checking, this repo uses pre-commit hooks. The following should be installed in the local workstation

* [pre-commit](https://pre-commit.com/)
* [terraform cli](https://developer.hashicorp.com/terraform/downloads)
* [terraform-docs](https://terraform-docs.io/)
* [checkov](https://github.com/bridgecrewio/checkov)

After the first checkout locally, run the following command to initialize the pre-commit hooks.

```bash
pre-commit install  --hook-type pre-push
```

It is possible to run the pre-commit hooks manually. To run all the pre-commit hooks for this repo, run

```bash
pre-commit run --all-files
```

To run just the checkov checker, run

```bash
pre-commit run checkov
```

To run just the `terraform-docs` hook to update the README, run

```bash
pre-commit run terraform-docs-go
```

See [.pre-commit-config.yaml](./.pre-commit-config.yaml) for other pre-commit hooks that can be run.

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

## Making this work in your environment outside of MIT libraries

This repository is a part of an ecosystem of components designed to work in our AWS organization.  This component is responsible for a standardized setup of ECR repositories and a build process that goes in Github Actions and Makefiles.  On its own, this repository could be useful to you if you want to emulate how we deploy and promote containers across our AWS accounts, or utilize GitHub OIDC connections for depositing ECR containers to AWS.  Before this will deploy in your environment, you will need an OpenID Connect Provider.  We generate this in our "init" repo, but you could just as easily place it here and reference it directly.  

An example of that infrastructure is:

```terraform
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}
```

then replace all the ssm parameter references for `oidc_arn` with `aws_iam_openid_connect_provider.github.arn`

## Additional Reference

* [github-actions-push-to-aws-ecr-without-credentials-oidc](https://blog.tedivm.com/guides/2021/10/github-actions-push-to-aws-ecr-without-credentials-oidc/)
* [about-security-hardening-with-openid-connect](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#example-subject-claims)

## Related Assets

This is a core infrastructure repository that defines infrastructure related to ECS, ECR, and Fargate deployments. The following application infrastructure repositories depend on this repository:

* [Alma Hook](https://github.com/MITLibraries/mitlib-tf-workloads-almahook)
  * [Alma Webhook Lambdas](https://github.com/MITLibraries/alma-webhook-lambdas)
* [Alma Patron Load](https://github.com/MITLibraries/mitlib-tf-workloads-patronload)
  * [Alma Patron Load Application Container](https://github.com/MITLibraries/alma-patronload)
* [ASATI](https://github.com/MITLibraries/mitlib-tf-workloads-asati)
  * [ASATI Application Container](https://github.com/MITLibraries/asati)
* [Carbon](https://github.com/MITLibraries/mitlib-tf-workloads-carbon)
* [CDPS](https://github.com/MITLibraries/mitlib-tf-workloads-cdps-storage)
  * [S3 BagIt Validator](https://github.com/MITLibraries/s3-bagit-validator)
  * [CDPS CURT](https://github.com/MITLibraries/cdps-curt)
* [DSC](https://github.com/MITLibraries/mitlib-tf-workloads-dsc)
  * [DSC Application Container](https://github.com/MITLibraries/dspace-submission-composer)
* [DSS](https://github.com/MITLibraries/mitlib-tf-workloads-dss)
  * [DSpace Submission Service Application Container](https://github.com/MITLibraries/dspace-submission-service)
  * [ETD](https://github.com/MITLibraries/mitlib-tf-workloads-etd)
* [HRQB](https://github.com/MITLibraries/mitlib-tf-workloads-hrqb-loader)
  * [HRQB Client](https://github.com/MITLibraries/hrqb-client)
* [Matomo](https://github.com/MITLibraries/mitlib-tf-workloads-matomo)
  * [Matomo Application Container](https://github.com/MITLibraries/docker-matomo)
* [PPOD](https://github.com/MITLibraries/mitlib-tf-workloads-ppod)
  * [PPOD Application Container](https://github.com/MITLibraries/ppod)
* [TIMDEX](https://github.com/MITLibraries/mitlib-tf-workloads-timdex-infrastructure)
  * [TIMDEX Application Container](https://github.com/MITLibraries/timdex)
  * [TIMDEX Dataset API](https://github.com/MITLibraries/timdex-dataset-api)
  * [TIMDEX Index Manager](https://github.com/MITLibraries/timdex-index-manager)
  * [TIMDEX Pipeline Lambdas](https://github.com/MITLibraries/timdex-pipeline-lambdas)
  * [TIMDEX UI](https://github.com/MITLibraries/timdex-ui)
  * [TIMDEX Simulator](https://github.com/MITLibraries/timdex-simulator)
* [WCD2Reshare](https://github.com/MITLibraries/mitlib-tf-workloads-wcd2reshare)
  * [WCD2Reshare Application Container](https://github.com/MITLibraries/wcd2reshare)
* **DEPRECATED**: [Wiley](https://github.com/MITLibraries/mitlib-tf-workloads-wiley)
  * **DEPRECATED**: [Wiley Deposits Application Container](https://github.com/MITLibraries/mitlib-tf-workloads-wiley)

## Maintainers

* Owner: See [CODEOWNERS](./.github/CODEOWNERS)
* Team: See [CODEOWNERS](./.github/CODEOWNERS)
* Last Maintenance: 2025-03

## TF markdown is automatically inserted at the bottom of this file, nothing should be written beyond this point

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

| Name | Source | Version |
|------|--------|---------|
| ecr\_alma\_webhook\_lambdas | ./modules/ecr | n/a |
| ecr\_asati | ./modules/ecr | n/a |
| ecr\_bursar | ./modules/ecr | n/a |
| ecr\_carbon | ./modules/ecr | n/a |
| ecr\_cdps\_curt | ./modules/ecr | n/a |
| ecr\_cdps\_s3\_bagit\_validator | ./modules/ecr | n/a |
| ecr\_creditcardslips | ./modules/ecr | n/a |
| ecr\_dsc | ./modules/ecr | n/a |
| ecr\_dss | ./modules/ecr | n/a |
| ecr\_hrqb\_client | ./modules/ecr | n/a |
| ecr\_matomo | ./modules/ecr | n/a |
| ecr\_oaiharvester | ./modules/ecr | n/a |
| ecr\_patronload | ./modules/ecr | n/a |
| ecr\_ppod | ./modules/ecr | n/a |
| ecr\_sapinvoices | ./modules/ecr | n/a |
| ecr\_sapinvoices\_ui | ./modules/ecr | n/a |
| ecr\_timdex\_browsertrix | ./modules/ecr | n/a |
| ecr\_timdex\_geo | ./modules/ecr | n/a |
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
| asati\_fargate\_dev\_build\_workflow | Full contents of the dev-build.yml for the asati repo |
| asati\_fargate\_makefile | Full contents of the Makefile for the asati repo (allows devs to push to Dev account only) |
| asati\_fargate\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the asati repo |
| asati\_fargate\_stage\_build\_workflow | Full contents of the stage-build.yml for the asati repo |
| browsertrix\_dev\_build\_workflow | Full contents of the dev-build.yml for the browsertrix-harvester repo |
| browsertrix\_makefile | Full contents of the Makefile for the browsertrix-harvester repo (allows devs to push to Dev account only) |
| browsertrix\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the browsertrix-harvester repo |
| browsertrix\_stage\_build\_workflow | Full contents of the stage-build.yml for the browsertrix-harvester repo |
| bursar\_dev\_build\_workflow | Full contents of the dev-build.yml for the alma-bursartransfer repo |
| bursar\_makefile | Full contents of the Makefile for the alma-bursartransfer repo (allows devs to push to Dev account only) |
| bursar\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the alma-bursartransfer repo |
| bursar\_stage\_build\_workflow | Full contents of the stage-build.yml for the alma-bursartransfer repo |
| carbon\_dev\_build\_workflow | Full contents of the dev-build.yml for the carbon repo |
| carbon\_makefile | Full contents of the Makefile for the carbon repo (allows devs to push to Dev account only) |
| carbon\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the carbon repo |
| carbon\_stage\_build\_workflow | Full contents of the stage-build.yml for the carbon repo |
| cdps\_curt\_dev\_build\_workflow | Full contents of the dev-build.yml for the cdps-curt repo |
| cdps\_curt\_makefile | Full contents of the Makefile for the cdps-curt repo (allows devs to push to Dev account only) |
| cdps\_curt\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the cdps-curt repo |
| cdps\_curt\_stage\_build\_workflow | Full contents of the stage-build.yml for the cdps-curt repo |
| creditcardslips\_dev\_build\_workflow | Full contents of the dev-build.yml for the alma-creditcardslips repo |
| creditcardslips\_makefile | Full contents of the Makefile for the alma-creditcardslips repo (allows devs to push to Dev account only) |
| creditcardslips\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the alma-creditcardslips repo |
| creditcardslips\_stage\_build\_workflow | Full contents of the stage-build.yml for the alma-creditcardslips repo |
| dsc\_fargate\_dev\_build\_workflow | Full contents of the dev-build.yml for the dsc repo |
| dsc\_fargate\_makefile | Full contents of the Makefile for the dsc repo (allows devs to push to Dev account only) |
| dsc\_fargate\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the dsc repo |
| dsc\_fargate\_stage\_build\_workflow | Full contents of the stage-build.yml for the dsc repo |
| dss\_fargate\_dev\_build\_workflow | Full contents of the dev-build.yml for the dss repo |
| dss\_fargate\_makefile | Full contents of the Makefile for the dss repo (allows devs to push to Dev account only) |
| dss\_fargate\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the dss repo |
| dss\_fargate\_stage\_build\_workflow | Full contents of the stage-build.yml for the dss repo |
| geo\_dev\_build\_workflow | Full contents of the dev-build.yml for the geo-harvester repo |
| geo\_makefile | Full contents of the Makefile for the geo-harvester repo (allows devs to push to Dev account only) |
| geo\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the geo-harvester repo |
| geo\_stage\_build\_workflow | Full contents of the stage-build.yml for the geo-harvester repo |
| hrqb\_client\_fargate\_dev\_build\_workflow | Full contents of the dev-build.yml for the hrqb-client repo |
| hrqb\_client\_fargate\_makefile | Full contents of the Makefile for the hrqb-client repo (allows devs to push to Dev account only) |
| hrqb\_client\_fargate\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the hrqb-client repo |
| hrqb\_client\_fargate\_stage\_build\_workflow | Full contents of the stage-build.yml for the hrqb-client repo |
| matomo\_fargate\_dev\_build\_workflow | Full contents of the dev-build.yml for the matomo repo |
| matomo\_fargate\_makefile | Full contents of the Makefile for the matomo repo (allows devs to push to Dev account only) |
| matomo\_fargate\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the matomo repo |
| matomo\_fargate\_stage\_build\_workflow | Full contents of the stage-build.yml for the matomo repo |
| oaiharvester\_dev\_build\_workflow | Full contents of the dev-build.yml for the oaiharvester repo |
| oaiharvester\_makefile | Full contents of the Makefile for the oaiharvester repo (allows devs to push to Dev account only) |
| oaiharvester\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the oaiharvester repo |
| oaiharvester\_stage\_build\_workflow | Full contents of the stage-build.yml for the oaiharvester repo |
| patronload\_dev\_build\_workflow | Full contents of the dev-build.yml for the alma-patronload repo |
| patronload\_makefile | Full contents of the Makefile for the alma-patronload repo (allows devs to push to Dev account only) |
| patronload\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the alma-patronload repo |
| patronload\_stage\_build\_workflow | Full contents of the stage-build.yml for the alma-patronload repo |
| ppod\_dev\_build\_workflow | Full contents of the dev-build.yml for the ppod repo |
| ppod\_makefile | Full contents of the Makefile for the ppod repo (allows devs to push to Dev account only) |
| ppod\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the ppod repo |
| ppod\_stage\_build\_workflow | Full contents of the stage-build.yml for the ppod repo |
| s3\_bagit\_validator\_dev\_build\_workflow | Full contents of the dev-build.yml for the s3-bagit-validator repo |
| s3\_bagit\_validator\_makefile | Full contents of the Makefile for the s3-bagit-validator repo (allows devs to push to Dev account only) |
| s3\_bagit\_validator\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the s3-bagit-validator repo |
| s3\_bagit\_validator\_stage\_build\_workflow | Full contents of the stage-build.yml for the s3-bagit-validator repo |
| sapinvoices\_dev\_build\_workflow | Full contents of the dev-build.yml for the alma-sapinvoices repo |
| sapinvoices\_makefile | Full contents of the Makefile for the alma-sapinvoices repo (allows devs to push to Dev account only) |
| sapinvoices\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the alma-sapinvoices repo |
| sapinvoices\_stage\_build\_workflow | Full contents of the stage-build.yml for the alma-sapinvoices repo |
| sapinvoices\_ui\_dev\_build\_workflow | Full contents of the dev-build.yml for the alma-sapinvoices-ui repo |
| sapinvoices\_ui\_makefile | Full contents of the Makefile for the alma-sapinvoices-ui repo (allows devs to push to Dev account only) |
| sapinvoices\_ui\_prod\_promote\_workflow | Full contents of the prod-promote.yml for the alma-sapinvoices-ui repo |
| sapinvoices\_ui\_stage\_build\_workflow | Full contents of the stage-build.yml for the alma-sapinvoices-ui repo |
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
