resource "aws_ecs_cluster" "production" {
  name = "${var.ecs_cluster_name}-cluster"
}

resource "aws_ecs_task_definition" "client-app" {
  family                    = "client-app"
  task_role_arn             = aws_iam_role.ecs-host-role.arn
  execution_role_arn        = aws_iam_role.ecs-host-role.arn
  requires_compatibilities  = ["FARGATE"]
  network_mode              = "awsvpc"
  memory                    = "512"
  cpu                       = "256"
  container_definitions     = templatefile("templates/client_app.json.tftpl", {
    docker_image_url_client = "${module.registry.client_url}:prod"
    region                  = "${var.region}"
  })
}

resource "aws_ecs_task_definition" "api-app" {
  family                   = "api-app"
  task_role_arn            = aws_iam_role.ecs-host-role.arn
  execution_role_arn       = aws_iam_role.ecs-host-role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  depends_on               = [aws_db_instance.production, aws_elasticache_cluster.production-cache, module.public-bucket]
  container_definitions    = templatefile("templates/api_app.json.tftpl", {
    docker_image_url_api   = "${module.registry.api_url}:prod"
    region                 = "${var.region}"
    secret_key             = "${var.secret_key}"
    database_url           = "postgres://${var.rds_username}:${var.rds_password}@${aws_db_instance.production.endpoint}/api_prod"
    redis_url              = "redis://${aws_elasticache_cluster.production-cache.cache_nodes[0].address}:6379"
    bucket_url             = "${module.public-bucket.bucket_dns}"
  })
}

resource "aws_ecs_service" "client-prod-service" {
  name            = "${var.ecs_cluster_name}-client-service"
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.client-app.arn
  desired_count   = var.app_count
  depends_on      = [aws_alb_listener.ecs-alb-http-listener, aws_iam_role_policy.ecs-service-role-policy]
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_alb_target_group.default-target-group.arn
    container_name   = "client-app"
    container_port   = 80
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_service" "api-prod-service" {
  name            = "${var.ecs_cluster_name}-api-service"
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.api-app.arn
  desired_count   = var.app_count
  depends_on      = [aws_alb_listener.ecs-alb-http-listener, aws_iam_role_policy.ecs-service-role-policy]
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_alb_target_group.api-target-group.arn
    container_name   = "api-app"
    container_port   = 5000
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
    assign_public_ip = true
  }
}