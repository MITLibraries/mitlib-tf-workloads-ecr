### Outputs

# ecr repository_name
output "repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.this.name
  sensitive   = false
}

# ecr repository_url
output "repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.this.repository_url
  sensitive   = false
}

# ecr role so that we can add the updatefunctioncode to it after the lambda itself is created
output "gha_role" {
  description = "Github action role used to update the ECR repository"
  value       = data.aws_region.current.name == "us-east-1" ? aws_iam_role.gha_this[0].name : null
  sensitive   = false
}

# pass back the repo_name that was passed in to the module
output "repo_name" {
  description = "The repo_name that was passed in to the module for naming purposes"
  value       = var.repo_name
  sensitive   = false
}
