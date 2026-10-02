variable "environment" {
    description = "Entorno de despliegue"
    type = string
}

variable "application" {
    description = "Nombre de la aplicación"
    type = string
}

variable "sqs_queue_arn" {
    description = "ARN de la cola SQS"
    type = string
}

variable "s3_bucket_arn" {
    description = "ARN del bucket de S3"
    type = string
}