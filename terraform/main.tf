module "network" {
  source                  = "./modules/network"

  public_subnet_1_cidr    = "10.0.1.0/24"
  public_subnet_2_cidr    = "10.0.2.0/24"
  private_subnet_1_cidr   = "10.0.3.0/24"
  private_subnet_2_cidr   = "10.0.4.0/24"
  availability_zones      = ["eu-west-3b", "eu-west-3c", "eu-west-3c"]
}

module "iam" {
  source                  = "./modules/iam"
}

module "public-bucket" {
  source                  = "./modules/s3"

  bucket_name             = var.s3_bucket
}

module "registry" {
  source                  = "./modules/ecr"

  client_name             = var.client_registry_name
  api_name                = var.api_registry_name
}

module "rds" {
  source                  = "./modules/rds"

  db_name                 = var.rds_db_name
  db_password             = var.rds_password
  db_subnets              = module.network.private_subnets
  db_username             = var.rds_username
  db_identifier           = var.rds_db_identifier
  instance_class          = var.rds_instance_class
  security_groups         = [aws_security_group.rds.id]
}

module "redis" {
  source                  = "./modules/redis"

  cluster_name            = var.redis_cluster_name
  node_type               = var.redis_node_type
  port                    = var.redis_port
}

module "keys" {
  source                  = "./modules/keypair"

  key_pair_name           = "${var.ecs_cluster_name}_key_pair"
  ssh_pubkey_file         = var.ssh_pubkey_file
}

module "logs" {
  source                  = "./modules/logs"
  
  api_group_name          = var.logs_api_group_name
  api_stream_name         = var.logs_api_stream_name
  client_group_name       = var.logs_client_group_name
  client_stream_name      = var.logs_client_stream_name
}