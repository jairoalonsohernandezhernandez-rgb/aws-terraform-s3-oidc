# 1. Dead Letter Queue (DLQ) para capturar mensajes fallidos
resource "aws_sqs_queue" "dlq" {
  name                      = "${var.queue_name}-dlq"
  message_retention_seconds = 1209600 # 14 días (máximo permitido por AWS para inspección de fallos)
  tags                      = merge(var.tags, { Name = "${var.queue_name}-dlq" })
}

# 2. Cola Principal de mensajes
resource "aws_sqs_queue" "main" {
  name                       = var.queue_name
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  # Conecta la cola principal con la DLQ mediante la política de redirección
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = merge(var.tags, { Name = var.queue_name })
}