resource "aws_ecs_cluster" "production" {
  name = "${var.ecs_cluster_name}-cluster"
}

data "template_file" "client-app" {
  template = file("templates/client_app.json.tpl")

  vars = {
    docker_image_url_client = var.docker_image_url_client
    region                  = var.region
  }
}

data "template_file" "api-app" {
  template = file("templates/api_app.json.tpl")

  vars = {
    docker_image_url_api   = var.docker_image_url_api
    region                 = var.region
    secret_key             = var.secret_key
    database_url           = "postgres://webapp:${var.rds_password}@${aws_db_instance.production.endpoint}/api_prod"
  }
}

resource "aws_ecs_task_definition" "client-app" {
  family                   = "client-app"
  task_role_arn            = aws_iam_role.ecs-host-role.arn
  execution_role_arn       = aws_iam_role.ecs-host-role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  container_definitions    = data.template_file.client-app.rendered
}

resource "aws_ecs_task_definition" "api-app" {
  family                   = "api-app"
  task_role_arn            = aws_iam_role.ecs-host-role.arn
  execution_role_arn       = aws_iam_role.ecs-host-role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  container_definitions    = data.template_file.api-app.rendered
  depends_on               = [aws_db_instance.production]
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