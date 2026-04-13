output "api_endpoint" {
  value = "${aws_apigatewayv2_stage.main.invoke_url}/hello"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.lambda_bucket.bucket
}

output "s3_processor_arn" {
  value = aws_lambda_function.s3_processor.arn
}