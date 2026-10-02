data "archive_file" "lambda_zip" {
    type = "zip"
    source_dir = "${path.module}/src"
    output_path = "${path.module}/files/lambda_payload.zip"
}

resource "aws_lambda_function" "lambda_principal" {
    function_name = var.function_name
    filename = data.archive_file.lambda_zip.output_path
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    role = var.role_arn
    runtime = "nodejs22.x"
    handler = "index.handler"
    memory_size = 128
    timeout = 30
    
    environment {
        variables = {
            ENVIRONMENT = var.environment
            LOG_LEVEL = var.log_level
            S3_BUCKET_NAME = var.s3_bucket_id
        }
    }

    tags = {
        Environment = var.environment
        Application = var.application
    }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
    event_source_arn = var.sqs_queue_arn
    function_name = aws_lambda_function.lambda_principal.arn
    batch_size = 10
}

