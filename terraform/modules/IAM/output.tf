output "lambda_role_arn" {
  description = "ARN de el rol de la función Lambda"
  value = aws_iam_role.lambda_exec_role.arn
}

output "apigateway_sqs_role_arn" {
    description = "ARN del rol de API Gateway para envío de datos hacia SQS"
    value = aws_iam_role.apigateway_sqs_role.arn
}