// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of PurpleTeam.

// PurpleTeam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// PurpleTeam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

resource "aws_lb" "sut" {
  load_balancer_type = "network"
  // internal can only be accessed internaly to VPC or via VPC link, as is the case for API Gateway.
  internal = true
  // https://www.terraform.io/docs/configuration/resources.html#create_before_destroy
  //lifecycle { create_before_destroy = true }
  name = "sut-nlb"
  subnets = var.public_subnet_ids
  // idle_timeout = 60 // Default.
  tags = {
        Name = "sut-nlb"
        source = "iac-nw-nlb"
  }
}

resource "aws_lb_target_group" "sut" {
  // Doc: https://www.terraform.io/docs/configuration/resources.html#when-to-use-for_each-instead-of-count
  // Doc: https://www.terraform.io/docs/configuration/expressions.html#references-to-named-values
  // Doc: https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
  for_each = var.suts_attributes

  name                 = "sut-nlb-tg-${each.key}"
  port                 = each.value.container_port
  protocol             = "TCP"
  vpc_id               = var.vpc_id

  // https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#deregistration-delay
  // deregistration_delay = 300 // Default.

  health_check {
    interval            = "30" // Only 10 and 30 is supported for target groups with TCP protocol
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    protocol            = "HTTP"
  }

  tags = {
    source = "iac-nw-nlb"
  }

  // Without the following, Terraform apply needs to be run twice.
  //   First time we get an error in ecs/ecs.tf aws_ecs_service.s1 saying that the targetGroupArn does not have an associated load balancer. This is because the load balancer is not created before this aws_lb_target_group.
  //   Second time is fine because the load balancer already exists.
  depends_on = [aws_lb.sut]
}

// Doc: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-limits.html
// Can have up to 50 listeners per LB.
// Can have up to 50 NLBs per region.
resource "aws_lb_listener" "cli_tcp" {
  for_each = var.suts_attributes

  load_balancer_arn = aws_lb.sut.arn
  port              = lookup(var.suts_attributes[each.key], "sut_lb_listener_port")
  protocol          = "TCP" // or TLS
  //certificate_arn   = var.api_aws_acm_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sut[each.key].arn
  }

  depends_on = [aws_lb.sut]
}
