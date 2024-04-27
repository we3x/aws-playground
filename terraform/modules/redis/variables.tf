variable "cluster_name" {
  description = "redis cluster name"
  type        = string
}

variable "node_type" {
  description = "redis instance type"
  type        = string
}

variable "port" {
  description = "redis port"
  type        = number
}