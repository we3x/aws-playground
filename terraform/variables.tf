# core

variable "region" {
  description = "The AWS region to create resources in."
  default     = "eu-west-3"
}

# networking

variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}
variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.2.0/24"
}
variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}
variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
  default     = "10.0.4.0/24"
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-west-3b", "eu-west-3c", "eu-west-3c"]
}

# Security groups

# Load Balancer

variable "health_check_path_client" {
  description = "Health check path for the default target group"
  default     = "/"
}
variable "health_check_path_api" {
  description = "Health check path for the default target group"
  default     = "/ping"
}

# IAM

# logs
variable "log_retention_in_days" {
  default = 30
}

# key pair

variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

# ecs

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  default     = "sysblink-production"
}
variable "docker_image_url_client" {
  description = "Docker client image to run in the ECS cluster"
  default     = "027485240632.dkr.ecr.eu-west-3.amazonaws.com/sysblink-client:prod"
}
variable "docker_image_url_api" {
  description = "Docker users image to run in the ECS cluster"
  default     = "027485240632.dkr.ecr.eu-west-3.amazonaws.com/sysblink-api:prod"
}
variable "app_count" {
  description = "Number of Docker containers to run"
  default     = 1
}
variable "secret_key" {
  description = "Flask Secret Key"
  default     = "IrlXZemJhdSYzNcHsLbTGyMURVhWY56T"
}

# rds
variable "rds_db_name" {
  description = "RDS database name"
  default     = "api_prod"
}
variable "rds_username" {
  description = "RDS database username"
  default     = "webapp"
}
variable "rds_password" {
  description = "RDS database password"
}
variable "rds_instance_class" {
  description = "RDS instance type"
  default     = "db.t3.micro"
}