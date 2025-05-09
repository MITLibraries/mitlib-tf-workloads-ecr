##############################################################################
##############################################################################
# Create the ECR repository to store the ECS image(s) along with a lifecycle 
# policy.
resource "aws_ecr_repository" "this" {
  #checkov:skip=CKV_AWS_51:We do not currently use releases for this, but may choose to turn this on in the future
  #checkov:skip=CKV_AWS_136:We do not store any private information in our images, encryption is unnecessary
  name = "${var.repo_name}-${var.environment}"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  #checkov:skip=CKV_AWS_136:We do not store any private information in our images, encryption is unnecessary 
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
### Since IAM Policies are "global" we ONLY create the policy statement if this
### module is called with the "default" us-east-1 AWS Provider so that we only
### have one IAM Policy that is good for all regions.
data "aws_iam_policy_document" "rw_this" {
  #checkov:skip=CKV_AWS_111:This policy needs unconstrained CreateRepository privileges
  #checkov:skip=CKV_AWS_356:This policy should allow "*" as a resource for restrictable actions
  count = data.aws_region.current.name == "us-east-1" ? 1 : 0
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
    resources = [
      "arn:aws:ecr:*:${data.aws_caller_identity.current.account_id}:repository/${aws_ecr_repository.this.name}"
    ]
  }
}

resource "aws_iam_policy" "rw_this" {
  count       = data.aws_region.current.name == "us-east-1" ? 1 : 0
  name        = "${var.repo_name}-ecr-rw-${var.environment}"
  description = "policy to allow read/write into ${var.repo_name} ECR"
  policy      = data.aws_iam_policy_document.rw_this[0].json

  tags = var.tags
}

# The trust policy that allows GitHub Actions OIDC-based connections from the 
# repository. The definition is explicitly linked to the name of the GitHub repo. 
data "aws_iam_policy_document" "gh_trust" {
  count = data.aws_region.current.name == "us-east-1" ? 1 : 0
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
  count              = data.aws_region.current.name == "us-east-1" ? 1 : 0
  name               = "${var.repo_name}-gha-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.gh_trust[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "gha_ecr_rw" {
  count      = data.aws_region.current.name == "us-east-1" ? 1 : 0
  role       = aws_iam_role.gha_this[0].name
  policy_arn = aws_iam_policy.rw_this[0].arn
}
resource "aws_iam_role_policy_attachment" "gha_ecr_login" {
  count      = data.aws_region.current.name == "us-east-1" ? 1 : 0
  role       = aws_iam_role.gha_this[0].name
  policy_arn = var.login_policy_arn
}
