### This policy can be shared by any role that needs a login policy attached.
### We set it up once for use in all apps ECR's


data "aws_iam_policy_document" "login" {
  statement {
    sid     = "ECRGetAuthorizationToken"
    effect  = "Allow"
    actions = ["ecr:GetAuthorizationToken"]

    resources = ["*"]
  }
}
### Login policy is shared by all roles
resource "aws_iam_policy" "login" {
  name        = "ECR-login-shared-${var.environment}"
  description = "Allow call to ecr:GetAuthorizationToken"
  policy      = data.aws_iam_policy_document.login.json
}