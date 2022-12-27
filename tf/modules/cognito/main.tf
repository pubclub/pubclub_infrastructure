resource "aws_cognito_user_pool" "pool" {
  name = var.user_pool_name

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length = 6
  }

  dynamic "schema" {
    for_each = var.schema
    content {
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = true
      name                     = schema.value.name
      required                 = true

      string_attribute_constraints {
        min_length = 1
        max_length = 256
      }
    }
  }

  lambda_config {
    post_confirmation = "arn:aws:lambda:${var.region}:${var.project_id}:function:${var.lambda_function_name}"
  }

}

resource "aws_cognito_user_pool_client" "client" {
  name         = var.user_pool_client_name
  user_pool_id = aws_cognito_user_pool.pool.id
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}
