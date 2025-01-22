################################################################################
################################################################################
# Create the ECR repository to store the ECS image(s) along with a lifecycle 
# policy.
resource "aws_ecr_repository" "this" {
  #checkov:skip=CKV_AWS_51:We do not currently use releases for this, but may choose to turn this on in the future
  #checkov:skip=CKV_AWS_136:We dont store any private information in our images, encyption is unncessary
  name = "${var.repo_name}-${var.environment}"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  #checkov:skip=CKV_AWS_136:We dont store any private information in our images, encyption is unncessary 
  #checkov:skip=CKV_AWS_163:We do not use image scanning by AWS right now
  #checkov:skip=CKV_AWS_51:We do not currently use releases for this, but may choose to turn this on in the future
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 5 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
    }]
  })
}

### Read-write permissions ECR repository
data "aws_iam_policy_document" "rw_this" {
  #checkov:skip=CKV_AWS_111:This policy needs unconstrained CreateRepository privileges
  #checkov:skip=CKV_AWS_356:This policy should allow "*" as a resource for restrictable actions
  statement {
    actions = [
      "ecr:CreateRepository",
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DeleteRepository",
      "ecr:DescribeImages",
      "ecr:DescribeImageScanFindings",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:ListTagsForResource",
      "ecr:PutImage",
      "ecr:TagResource",
      "ecr:UntagResource",
      "ecr:UploadLayerPart",
    ]
    resources = [aws_ecr_repository.this.arn]
  }
}

resource "aws_iam_policy" "rw_this" {
  name        = "${var.repo_name}-ecr-rw-${var.environment}"
  description = "policy to allow read/write into ${var.repo_name} ECR"
  policy      = data.aws_iam_policy_document.rw_this.json

  tags = var.tags
}

# The trust policy that allows GitHub Actions OIDC-based connections from the 
# repository. The definition is explicitly linked to the name of the GitHub repo. 
data "aws_iam_policy_document" "gh_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.oidc_arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.gh_organization}/${var.repo_name}:*"] # "repo:MITLibraries//<repo-name>:ref:refs/branch/${var.environment}" eventually
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# Role for GitHub Action OIDC connections from the lambdas repository
resource "aws_iam_role" "gha_this" {
  name               = "${var.repo_name}-gha-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.gh_trust.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "gha_ecr_rw" {
  role       = aws_iam_role.gha_this.name
  policy_arn = aws_iam_policy.rw_this.arn
}
resource "aws_iam_role_policy_attachment" "gha_ecr_login" {
  role       = aws_iam_role.gha_this.name
  policy_arn = var.login_policy_arn
}
