variable "bucket_name" {
  description = "Bucket para almacenar en s3"
  type = string
}

variable "force_destroy" {
  description = "Indica si se debe forzar la destrucción del bucket"
  type = bool
  default = false
}

variable "environment" {
  description = "Entorno de despliegue"
  type = string
}

variable "application" {
  description = "Nombre de la aplicación"
  type = string
}