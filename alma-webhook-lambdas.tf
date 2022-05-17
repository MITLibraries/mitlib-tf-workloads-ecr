################################################################################
################################################################################
# A repository in ECR to hold the almahook ECS image(s) along with a lifecycle 
# policy.
resource "aws_ecr_repository" "almahook" {
  name = "alma-webhook-lambdas-${var.environment}"
}

resource "aws_ecr_lifecycle_policy" "almahook" {
  #checkov:skip=CKV_AWS_136:We dont store any private information in our images, encyption is unncessary 
  #checkov:skip=CKV_AWS_163:We do not use image scanning by AWS right now
  #checkov:skip=CKV_AWS_51:We do not currently use releases for this, but may choose to turn this on in the future
  repository = aws_ecr_repository.almahook.name

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


### Permissions to read and write to the ECR
### Each ECR has its own permissions policy

data "aws_iam_policy_document" "rw_almahook" {
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
      "ecr:CompleteLayerUpload",
      "ecr:DeleteRepository",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:ListTagsForResource",
      "ecr:PutImage",
      "ecr:TagResource",
      "ecr:UntagResource",
      "ecr:UploadLayerPart",
    ]

    resources = [aws_ecr_repository.almahook.arn]
  }
}



resource "aws_iam_policy" "rw_almahook" {
  name        = "almahook-ecr-rw-${var.environment}"
  description = "policy to allow read/write into almahook ECR"
  policy      = data.aws_iam_policy_document.rw_almahook.json
}


# The trust policy that allows GitHub Actions OIDC-based connections from the 
# alma-webhook-lambdas repository. The definition is explicitly linked to the name of the
# alma-webhook-lambdas repo. 
data "aws_iam_policy_document" "gh_almahook_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [data.aws_ssm_parameter.oidc_arn.value]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:MITLibraries/alma-webhook-lambdas:*"] # "repo:MITLibraries//timdex-pipeline-lambdas:ref:refs/branch/${var.environment}" eventually
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# Role for GitHub Action OIDC connections from the lambdas repository
resource "aws_iam_role" "gha_almahook" {
  name               = "almahook-gha-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.gh_almahook_trust.json
}

resource "aws_iam_role_policy_attachment" "almahook_ecr_rw" {
  role       = aws_iam_role.gha_almahook.name
  policy_arn = aws_iam_policy.rw_almahook.arn
}
resource "aws_iam_role_policy_attachment" "almahook_ecr_login" {
  role       = aws_iam_role.gha_almahook.name
  policy_arn = aws_iam_policy.login.arn
}

### Outputs
# almahook ecr repository_url
# Type:string datatype:text format:string
resource "aws_ssm_parameter" "almahook_ecr_repository_url" {
  #checkov:skip=CKV2_AWS_34:By default we are not encrypting parameters in tfoutput_ssm_path
  type        = "String"
  name        = "${var.tfoutput_ssm_path}/almahook-ecr-repository-url"
  value       = aws_ecr_repository.almahook.repository_url
  description = "The URL of the almahook repository"
  overwrite   = true
}

# almahook ecr role so that we can add the updatefunctioncode to it after the lambda itself is created
# Type:string datatype:text format:string
resource "aws_ssm_parameter" "almahook_gha_role" {
  #checkov:skip=CKV2_AWS_34:By default we are not encrypting parameters in tfoutput_ssm_path
  type        = "String"
  name        = "${var.tfoutput_ssm_path}/almahook-gha-role"
  value       = aws_iam_role.gha_almahook.name
  description = "Github action role used to update the ecr repo"
  overwrite   = true
}
