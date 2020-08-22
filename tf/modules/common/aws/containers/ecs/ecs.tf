locals {
  // Todo: Once checked, remove these next two locals and consider removing them from iac project
  suts = keys(var.suts_attributes)
  sut_set = toset(local.suts)
  // ECS: The only bridge network mode available is default bridge (https://medium.com/pablo-perez/ecs-service-discovery-to-work-around-lack-of-user-defined-bridge-network-ecs-limitation-6fa6b9672d84)
  network_mode = "bridge"
  requires_compatibilities = ["EC2"]
  tag_source = "iac-contOrc-ecs"
}

//////////////////////////////
// Task
//////////////////////////////

// Doc: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
data "template_file" "sut" {
  for_each = var.suts_attributes

  template = "${file("${path.module}/taskDefinitions/${each.key}.tpl")}"

  vars = {
    container_name = each.value.name
    container_port = each.value.container_port
    host_port = each.value.host_port
    aws_region = var.aws_region
    aws_account_id = var.aws_account_id
    sut_key = each.key
    sut_environment = jsonencode(each.value.env)
  }
}

resource "aws_ecs_task_definition" "sut" {
  for_each = var.suts_attributes

  family = each.key
  container_definitions = data.template_file.sut[each.key].rendered
  execution_role_arn = var.ecs_task_execution_role

  // Doc: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-placement-constraints.html
  // Doc: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#constraints
  // placement_constraints {}
  network_mode = local.network_mode
  requires_compatibilities = local.requires_compatibilities

  tags = {
    Name = "task_def_${each.key}"
    source = local.tag_source
  }
}

//////////////////////////////
// SUT Cluster
//////////////////////////////

resource "aws_ecs_cluster" "sut" {
  // https://www.terraform.io/docs/configuration/resources.html#when-to-use-for_each-instead-of-count
  // https://www.terraform.io/docs/configuration/expressions.html#references-to-named-values
  // https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
  for_each = var.suts_attributes

  name = each.key
  tags = {
    Name = "sut-ecs"
    source = local.tag_source
  }
}

//////////////////////////////
// Service
//////////////////////////////

resource "aws_ecs_service" "sut" {
  for_each = aws_ecs_cluster.sut

  name = each.value.name
  cluster = aws_ecs_cluster.sut[each.key].id
  task_definition = aws_ecs_task_definition.sut[each.key].arn
  // Doc: https://www.terraform.io/docs/providers/aws/r/ecs_service.html#iam_role
  // Doc: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using-service-linked-roles.html
  iam_role = var.ecs_service_role
  desired_count = 1
  // Doc: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service_definition_parameters.html
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent = 100
  health_check_grace_period_seconds = 30

  // Doc: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-placement-strategies.html
  // ordered_placement_strategy {}

  // Doc: https://www.terraform.io/docs/providers/aws/r/ecs_service.html#scheduling_strategy
  // Doc: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service_definition_parameters.html
  scheduling_strategy = "REPLICA" // Default

  load_balancer {
      target_group_arn = var.aws_lb_target_groups[each.key].arn
      container_name = var.suts_attributes[each.key].name
      container_port = var.suts_attributes[each.key].container_port
  }

  tags = { source = local.tag_source }

  lifecycle {
    create_before_destroy = true
  }
}
