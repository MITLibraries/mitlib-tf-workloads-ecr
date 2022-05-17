################################################################################
################################################################################
# A repository in ECR to hold the ppod ECS image(s) along with a lifecycle 
# policy.
resource "aws_ecr_repository" "ppod" {
  name = "ppod-${var.environment}"
}

resource "aws_ecr_lifecycle_policy" "ppod" {
  #checkov:skip=CKV_AWS_136:We dont store any private information in our images, encyption is unncessary 
  #checkov:skip=CKV_AWS_163:We do not use image scanning by AWS right now
  #checkov:skip=CKV_AWS_51:We do not currently use releases for this, but may choose to turn this on in the future
  repository = aws_ecr_repository.ppod.name

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

data "aws_iam_policy_document" "rw_ppod" {
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

    resources = [aws_ecr_repository.ppod.arn]
  }
}



resource "aws_iam_policy" "rw_ppod" {
  name        = "ppod-ecr-rw-${var.environment}"
  description = "policy to allow read/write into ppod ECR"
  policy      = data.aws_iam_policy_document.rw_ppod.json
}


# The trust policy that allows GitHub Actions OIDC-based connections from the 
# ppod repository. The definition is explicitly linked to the name of the
# ppod repo. 
data "aws_iam_policy_document" "gh_ppod_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [data.aws_ssm_parameter.oidc_arn.value]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:MITLibraries/ppod:*"] # "repo:MITLibraries//timdex-pipeline-lambdas:ref:refs/branch/${var.environment}" eventually
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# Role for GitHub Action OIDC connections from the lambdas repository
resource "aws_iam_role" "gha_ppod" {
  name               = "ppod-gha-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.gh_ppod_trust.json
}

resource "aws_iam_role_policy_attachment" "ppod_ecr_rw" {
  role       = aws_iam_role.gha_ppod.name
  policy_arn = aws_iam_policy.rw_ppod.arn
}
resource "aws_iam_role_policy_attachment" "ppod_ecr_login" {
  role       = aws_iam_role.gha_ppod.name
  policy_arn = aws_iam_policy.login.arn
}

### Outputs
# ppod ecr repository_url
# Type:string datatype:text format:string
resource "aws_ssm_parameter" "ppod_ecr_repository_url" {
  #checkov:skip=CKV2_AWS_34:By default we are not encrypting parameters in tfoutput_ssm_path
  type        = "String"
  name        = "${var.tfoutput_ssm_path}/ppod-ecr-repository-url"
  value       = aws_ecr_repository.ppod.repository_url
  description = "The URL of the ppod repository"
  overwrite   = true
}

# ppod ecr role so that we can add the updatefunctioncode to it after the lambda itself is created
# Type:string datatype:text format:string
resource "aws_ssm_parameter" "ppod_gha_role" {
  #checkov:skip=CKV2_AWS_34:By default we are not encrypting parameters in tfoutput_ssm_path
  type        = "String"
  name        = "${var.tfoutput_ssm_path}/ppod-gha-role"
  value       = aws_iam_role.gha_ppod.name
  description = "Github action role used to update the ecr repo"
  overwrite   = true
}
