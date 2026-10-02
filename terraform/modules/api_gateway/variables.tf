variable "sqs_function_invoke_arn" {
    type = string
    description = "ARN del sqs para poder vincularlo"
}

variable "role_arn" {
    type = string
    description = "ARN del rol de API Gateway para enviar datos hacia SQS"
}