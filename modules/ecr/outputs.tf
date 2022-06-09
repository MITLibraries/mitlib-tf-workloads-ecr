
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
  value       = aws_iam_role.gha_this.name
  sensitive   = false
}
