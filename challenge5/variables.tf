variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}

variable "user_name" {
  description = "RDS username"
  type        = string
  sensitive   = true
}
