variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "zip_path" {
  description = "Lambda function zip file path"
  type        = string
}

variable "role_name" {
  description = "Lambda function iam role name"
  type        = string
}

variable "line_channel_access_token" {
  description = "LINE channel access token"
  type        = string
  sensitive   = true
}