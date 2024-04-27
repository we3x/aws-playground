variable "db_identifier" {
  description = "RDS database name"
  type        = string
}
variable "db_name" {
  description = "RDS database name"
  type        = string
}
variable "db_username" {
  description = "RDS database username"
  type        = string
}
variable "db_password" {
  description = "RDS database password"
  type        = string
}
variable "instance_class" {
  description = "RDS instance type"
  type        = string
}
variable "db_subnets" {
  description = "RDS subnets"
  type        = list(string)
}
variable "security_groups" {
  description = "RDS security-groups"
  type        = list(string)
}