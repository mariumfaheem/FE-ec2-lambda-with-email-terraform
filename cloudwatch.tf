resource "aws_cloudwatch_event_rule" "every_day" {
  name = "${var.name}-daily"
  schedule_expression = var.cron_schedule_enforce_bucket_encryption
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke" {
  function_name = module.lambda_function.lambda_function_name
  statement_id = "CloudWatchInvoke"
  action = "lambda:InvokeFunction"
  source_arn = aws_cloudwatch_event_rule.every_day.arn
  principal = "events.amazonaws.com"
}
resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule = aws_cloudwatch_event_rule.every_day.name
  arn = module.lambda_function.lambda_function_arn
  input = <<JSON
{
  "action": "True"
}
JSON
}
