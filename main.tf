resource "aws_s3_bucket" "builds" {
  bucket = var.lambda_s3_bucket
}

resource "aws_s3_object" "my_function" {
  bucket = aws_s3_bucket.builds.id
  key    = "${filemd5(local.my_function_source)}.zip"
  source = local.my_function_source
}

module "lambda_function" {
  depends_on = [aws_s3_object.my_function]
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.name
  description   = var.description
  handler       = "${var.lambda_file_name}.lambda_handler"
  runtime       = var.runtime

  create_package      = false
  s3_existing_package = {
    bucket = aws_s3_bucket.builds.id
    key    = aws_s3_object.my_function.id
  }
  environment_variables = {
    sender: var.sender
    receiver: var.receiver
    password: var.password
    REGION: var.region
    RMD_CYBER_SECURITY : var.rmd_cyber_security
    VPC_ID: var.vpc_id
  }
  create_lambda_function_url = true
  authorization_type         = "AWS_IAM"
  cors = {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }

  assume_role_policy_statements = {
    account_root = {
      effect  = "Allow",
      actions = ["sts:AssumeRole"],
      principals = {
        account_principal = {
          type        = "AWS",
          identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
        }
      }
    }
  }
  attach_policy_json = true
  policy_json        = <<-EOT
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ec2:*"
                ],
                "Resource": ["*"]
            }
        ]
    }
  EOT

  attach_policy_jsons = true
  policy_jsons = [
    <<-EOT
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Effect": "Allow",
                  "Action": [
                      "ec2:*"
                  ],
                  "Resource": ["*"]
              }
          ]
      }
    EOT
  ]
  number_of_policy_jsons = 1

  attach_policy = true
  policy        = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"

  attach_policies    = true
  policies           = ["arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess","arn:aws:iam::aws:policy/AmazonEC2FullAccess","arn:aws:iam::aws:policy/AmazonS3FullAccess"]
  number_of_policies = 1

  attach_policy_statements = true
  policy_statements = {
    ec2_read = {
      effect    = "Allow",
      actions   = ["ec2:*"],
      resources = ["*"]
    }
  }

  allowed_triggers = {
    OneRule = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.every_day.arn
    }
  }
  timeout = 60
  attach_cloudwatch_logs_policy = true
  attach_network_policy         = true
  attach_tracing_policy         = true
  create_current_version_allowed_triggers = false
  publish = true
  tags = local.mandatory_tags
  s3_object_tags = local.mandatory_tags
  role_tags = local.mandatory_tags
  cloudwatch_logs_tags = local.mandatory_tags

}

