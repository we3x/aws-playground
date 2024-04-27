resource "aws_db_subnet_group" "production" {
  name                    = "main"
  subnet_ids              = var.db_subnets
}

resource "aws_db_instance" "this" {
  identifier              = var.db_identifier
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = "5432"
  engine                  = "postgres"
  engine_version          = "16.2"
  instance_class          = var.instance_class
  allocated_storage       = "20"
  storage_encrypted       = false
  vpc_security_group_ids  = var.security_groups
  db_subnet_group_name    = aws_db_subnet_group.production.name
  multi_az                = false
  storage_type            = "gp2"
  publicly_accessible     = false
  backup_retention_period = 7
  skip_final_snapshot     = true
}