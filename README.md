# mitlib-tf-template

Template for Terraform repos for MIT Libraries.

After deploying this, the following steps must be completed.

1. Update the `terraform { }` block in `main.tf`. We now use the `cloud {}` block to link to workspaces in Terraform Cloud. The very first thing to do is set the correct tags in the `workspaces {}` block.
1. Update `main.tf` to include any additional Terraform Provider(s).
1. Update the `terraform { required_providers { } }` block in `versions.tf` to set the location and constraints on the additional providers.
1. **Optional**: Update the `locals {}` block in `main.tf` to provide a project-id.
1. Copy the `locals {}` block from the `deleteme.tf` file and paste it into each `.tf` file that will create named resources.
1. Delete the `deleteme.tf` file.
1. Delete the file tree below.

## File Tree

```bash
.
├── LICENSE
├── README.md
├── deleteme.tf
├── docs
│   └── adrs
│       └── 0001-record-architecture-decisions.md
├── main.tf
├── modules
│   └── README.md
├── providers.tf
├── tests
│   └── README.md
├── variables.tf
└── versions.tf
```

## TF markdown is automatically inserted at the bottom of this file, nothing should be written beyond this point

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.1 |
| aws | ~> 3.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

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
