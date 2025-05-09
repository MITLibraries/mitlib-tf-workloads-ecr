
### SSM_Outputs
# ecr repository_name
# Type:string datatype:text format:string
resource "aws_ssm_parameter" "ecr_repository_name" {
  #checkov:skip=CKV_AWS_337:By default we are not encrypting parameters in tfoutput_ssm_path
  #checkov:skip=CKV2_AWS_34:By default we are not encrypting parameters in tfoutput_ssm_path
  type        = "String"
  name        = "${var.tfoutput_ssm_path}/${var.repo_name}/ecr-repository-name"
  value       = aws_ecr_repository.this.name
  description = "The name of the ${var.repo_name} ECR repository"
  tags        = var.tags
}

# ecr repository_url
# Type:string datatype:text format:string
resource "aws_ssm_parameter" "ecr_repository_url" {
  #checkov:skip=CKV_AWS_337:By default we are not encrypting parameters in tfoutput_ssm_path
  #checkov:skip=CKV2_AWS_34:By default we are not encrypting parameters in tfoutput_ssm_path
  type        = "String"
  name        = "${var.tfoutput_ssm_path}/${var.repo_name}/ecr-repository-url"
  value       = aws_ecr_repository.this.repository_url
  description = "The URL of the ${var.repo_name} ECR repository"
  tags        = var.tags
}

# ecr role so that we can add the updatefunctioncode to it after the lambda itself is created
# Type:string datatype:text format:string
resource "aws_ssm_parameter" "gha_role" {
  #checkov:skip=CKV_AWS_337:By default we are not encrypting parameters in tfoutput_ssm_path
  #checkov:skip=CKV2_AWS_34:By default we are not encrypting parameters in tfoutput_ssm_path
  count       = data.aws_region.current.name == "us-east-1" ? 1 : 0
  type        = "String"
  name        = "${var.tfoutput_ssm_path}/${var.repo_name}/gha-role"
  value       = aws_iam_role.gha_this[0].name
  description = "Github action role used to update the ${var.repo_name} ECR repository"
  tags        = var.tags
}
