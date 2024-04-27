module "network" {
    source                  = "./modules/network"

    public_subnet_1_cidr    = "10.0.1.0/24"
    public_subnet_2_cidr    = "10.0.2.0/24"
    private_subnet_1_cidr   = "10.0.3.0/24"
    private_subnet_2_cidr   = "10.0.4.0/24"
    availability_zones      = ["eu-west-3b", "eu-west-3c", "eu-west-3c"]
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
    db_identifier           = var.rds_db_identifier
    db_password             = var.rds_password
    db_username             = var.rds_username
    instance_class          = var.rds_instance_class
    db_subnets              = module.network.private_subnets
    security_groups         = [aws_security_group.rds.id]
}