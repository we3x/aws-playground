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
variable "client_registry_name" {
  description = "Docker client ECR name"
  default     = "sysblink-client"
}
variable "api_registry_name" {
  description = "Docker users ECR name"
  default     = "sysblink-api"
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
variable "rds_db_identifier" {
  description = "RDS database name"
  default     = "sysblink-db-prod"
}
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

# redis
variable "redis_cluster" {
  description = "redis cluster name"
  default     = "sysblink-cache-prod"
}

variable "redis_node_type" {
  description = "redis instance type"
  default     = "cache.t3.micro"
}

# s3
variable "s3_bucket" {
  description = "s3 bucket name"
  default     = "sysblink-bucket-prod"
}