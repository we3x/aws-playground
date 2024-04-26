module "public-bucket" {
    source = "./modules/s3"

    bucket_name = var.s3_bucket
}

module "registry" {
    source      = "./modules/ecr"

    client_name = var.client_registry_name
    api_name    = var.api_registry_name
}