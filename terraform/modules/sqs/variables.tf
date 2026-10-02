variable "queue_name" {
    type = string
    description = "Nombre del recurso de colas"
}

variable "delay_seconds" {
    type = number
    description = "Delay en segundos de la cola"
    default = 0
}

variable "max_message_size" {
    type = number
    description = "Tamaño maximo del mensaje"
    default = 262144
}

variable "message_retention_seconds" {
    type = number
    description = "Retencion de mensages en segundos"
    default = 345600
}

variable "receive_wait_time_seconds" {
    type = number
    description = "Tiempo en espera de recibimiento en segundos"
    default = 10
}

variable "visibility_timeout_seconds" {
    type = number
    description = "visibilidad del tiempo de espera en segundos"
    default = 30
}

variable "max_receive_count" {
    type = number
    description = "Maximo de conteo de recivimientos"
    default = 5
}

variable "tags" {
    type = map(string)
    description = "Etiquetas (tags) globales aplicadas a los recursos"
    default = {}
}