module "s3_bucket" {
  source      = "../../modules/s3_bucket"
  bucket_name = "jairo-dev-s3-labs-893271"
  force_destroy = true
  environment = "dev"
  application = "sistema-procesamiento-sqs"
}

module "lambda_function" {
  source = "../../modules/lambdas_vms"
  function_name = "procesador-eventos-dev"
  role_arn = module.iam.lambda_role_arn
  environment = "dev"
  log_level = "DEBUG"
  application = "sistema-procesamiento-sqs"

  s3_bucket_id = module.s3_bucket.bucket_id
  sqs_queue_arn = module.sqs_queue.queue_arn
}

module "sqs_queue" {
  source = "../../modules/sqs"
  queue_name = "sqs-dev-no1-queue-jairo"
  delay_seconds = 0
  max_message_size = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0
  visibility_timeout_seconds = 30
  max_receive_count = 5

  tags = {
    Environment = "dev"
    Application = "sistema-procesamiento-sqs"
  }
}

module "api_gateway" {
  source = "../../modules/api_gateway"
  sqs_function_invoke_arn = module.sqs_queue.queue_arn
  role_arn = module.iam.apigateway_sqs_role_arn
}

module "iam" {
  source = "../../modules/IAM"
  environment = "dev"
  application = "sistema-procesamiento-sqs"
  sqs_queue_arn = module.sqs_queue.queue_arn
  s3_bucket_arn = module.s3_bucket.bucket_arn
}