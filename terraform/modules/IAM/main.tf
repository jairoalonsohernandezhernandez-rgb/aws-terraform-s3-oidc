# Relación de confianza (Trust Policy) para Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-execution-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    Application = var.application
  }
}

# Política de permisos de Lambda (SQS + S3 + CloudWatch Logs)
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-execution-policy-${var.environment}"
  description = "Permite a Lambda consumir mensajes de S3/SQS y escribir logs en CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Permisos para consumir de SQS
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = var.sqs_queue_arn
      },
      # Permisos para escribir en S3
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = "${var.s3_bucket_arn}/*"
      },
      # Permisos para registros en CloudWatch Logs
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Vinculación de Política a Rol para Lambda
resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Relación de confianza (Trust Policy) para API Gateway
resource "aws_iam_role" "apigateway_sqs_role" {
  name = "apigateway-sqs-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    Application = var.application
  }
}

# Política de permisos para enviar mensajes a la cola SQS
resource "aws_iam_policy" "apigateway_sqs_policy" {
  name        = "apigateway-sqs-policy-${var.environment}"
  description = "Permite a API Gateway ejecutar sqs:SendMessage"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage"]
        Resource = var.sqs_queue_arn
      }
    ]
  })
}

# Vinculación de Política a Rol para API Gateway
resource "aws_iam_role_policy_attachment" "apigateway_sqs_attach" {
  role       = aws_iam_role.apigateway_sqs_role.name
  policy_arn = aws_iam_policy.apigateway_sqs_policy.arn
}