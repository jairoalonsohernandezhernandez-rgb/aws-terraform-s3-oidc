variable "function_name"  {
  description = "El nombre de la función Lambda"
  type = string
}

variable "role_arn"{
    description = "ARN del rol de IAM para la función Lambda"
    type = string
}

variable "environment" {
    description = "El entorno donde se procesarán los datos"
    type =string
}

variable "log_level" {
    description = "Nivel de log para la función Lambda"
    type = string
}

variable "s3_bucket_id" {
    description = "ID del bucket de S3 donde se almacenarán los datos"
    type = string
}

variable "application" {
    description = "Nombre de la aplicación que utiliza la función Lambda"
    type = string
}

variable "sqs_queue_arn" {
    description = "ARN de la cola SQS a la que se enviarán los mensajes"
    type = string
}