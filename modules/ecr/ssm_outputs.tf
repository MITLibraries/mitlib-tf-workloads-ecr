
### Outputs
# ecr repository_url
# Type:string datatype:text format:string
resource "aws_ssm_parameter" "ecr_repository_url" {
  #checkov:skip=CKV2_AWS_34:By default we are not encrypting parameters in tfoutput_ssm_path
  type        = "String"
  name        = "${var.tfoutput_ssm_path}/${var.repo_name}/ecr-repository-url"
  value       = aws_ecr_repository.this.repository_url
  description = "The URL of the ${var.repo_name} repository"
  overwrite   = true
}

# ecr role so that we can add the updatefunctioncode to it after the lambda itself is created
# Type:string datatype:text format:string
resource "aws_ssm_parameter" "gha_role" {
  #checkov:skip=CKV2_AWS_34:By default we are not encrypting parameters in tfoutput_ssm_path
  type        = "String"
  name        = "${var.tfoutput_ssm_path}/${var.repo_name}/gha-role"
  value       = aws_iam_role.gha_this.name
  description = "Github action role used to update the ${var.repo_name} ECR repo"
  overwrite   = true
}
