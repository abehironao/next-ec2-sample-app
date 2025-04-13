output "function_name" {
  description = "デプロイされた Lambda 関数名"
  value       = aws_lambda_function.this.function_name
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.this.api_endpoint
  description = "API Gateway のエンドポイント"
}