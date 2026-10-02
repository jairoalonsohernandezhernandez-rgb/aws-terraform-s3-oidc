output "lambda_function_arn" {
    description = "ARN de la función Lambda creada"
    value = aws_lambda_function.lambda_principal.arn
}

output "lambda_function_name" {
    description = "Nombre de la funcion Lambda creada"
    value = aws_lambda_function.lambda_principal.function_name
}

output "event_source_mapping_id" {
    description = "ID del mapeo de SQS hacia Lambda"
    value = aws_lambda_event_source_mapping.sqs_trigger.id
}