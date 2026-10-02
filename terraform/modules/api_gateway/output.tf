output "rest_api_id" {
  description = "El ID de la rest API Gateway"
  value = aws_api_gateway_rest_api.gateway_prueba.id
}

output "execution_arn" {
    description = "El ARN de la rest API Gateway"
    value = aws_api_gateway_rest_api.gateway_prueba.execution_arn
}

output "invoke_url" {
    description = "La URL de invocación de el dev de API Gateway"
    value = aws_api_gateway_stage.dev.invoke_url
}