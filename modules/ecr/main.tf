# Not much here other than capturing the caller_identity and aws_region

# Capture the AWS account number and capture the default managed key for SSM in KMS
data "aws_caller_identity" "current" {}

# Capture the AWS Region for the provider that was used to invoke this module call
data "aws_region" "current" {}
