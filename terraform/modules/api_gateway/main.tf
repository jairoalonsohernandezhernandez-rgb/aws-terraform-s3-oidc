resource "aws_api_gateway_rest_api" "gateway_prueba" {
    name = "gateway-jairo-001"
    description = "API para gestionar la interaccion con usuarios"
}

resource "aws_api_gateway_resource" "users" {
    rest_api_id = aws_api_gateway_rest_api.gateway_prueba.id
    parent_id = aws_api_gateway_rest_api.gateway_prueba.root_resource_id
    path_part = "users"
}

resource "aws_api_gateway_resource" "user_id" {
    rest_api_id = aws_api_gateway_rest_api.gateway_prueba.id
    parent_id = aws_api_gateway_resource.users.id
    path_part = "{id}"
}

resource "aws_api_gateway_method" "get_user" {
    rest_api_id = aws_api_gateway_rest_api.gateway_prueba.id
    resource_id = aws_api_gateway_resource.user_id.id
    http_method = "GET"
    authorization = "NONE"

    request_parameters = {
        "method.request.path.id" = true
    }

    request_validator_id = aws_api_gateway_request_validator.validator.id
}

resource "aws_api_gateway_request_validator" "validator" {
    name = "params-validator"
    rest_api_id = aws_api_gateway_resource.user_id.id
    validate_request_parameters = true
}

resource "aws_api_gateway_integration" "sqs_integration" {
    rest_api_id = aws_api_gateway_rest_api.gateway_prueba.id
    resource_id = aws_api_gateway_resource.user_id.id
    http_method = aws_api_gateway_method.get_user.http_method
    integration_http_method = "POST"
    type = "AWS"
    uri = var.sqs_function_invoke_arn
    credentials = var.role_arn
    request_parameters = {
        "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"    
    }

    request_templates = {
        "application/json" = "Action=SendMessage&MessageBody=$input.body"
    }
}

resource "aws_api_gateway_deployment" "deployment" {
    rest_api_id = aws_api_gateway_rest_api.gateway_prueba.id

    triggers = {
      redeployment = sha256(jsonencode([
        aws_api_gateway_resource.user_id.id,
        aws_api_gateway_method.get_user.id,
        aws_api_gateway_integration.sqs_integration.id,
      ]))
    }

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_api_gateway_stage" "dev" {
    deployment_id = aws_api_gateway_deployment.deployment.id
    rest_api_id = aws_api_gateway_rest_api.gateway_prueba.id
    stage_name = "dev"
}