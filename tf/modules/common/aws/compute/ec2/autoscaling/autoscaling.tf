// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of purpleteam.

// purpleteam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

data "template_file" "autoscaling_user_data" {
  for_each = var.suts_attributes

  template = file("${path.module}/userData/userData.tpl")
  vars = {
    ecs_cluster = each.key
  }
}

resource "aws_launch_template" "sut" {
  for_each = var.suts_attributes

  name = "sut-lt-${each.key}"

  instance_type = lookup(var.suts_attributes[each.key], "instance_type")

  image_id = lookup(var.ecs_image_id, var.aws_region)
  iam_instance_profile { arn = var.ecs_instance_profile }
  user_data = base64encode(data.template_file.autoscaling_user_data[each.key].rendered)

  // This is for configuring additional volumes above 30GB: https://www.terraform.io/docs/providers/aws/r/launch_template.html#block-devices
  //block_device_mappings

  //credit_specification
  //  cpu_credits probably best to be unlimited but need to be adjustable per SUT.
  //  Docs: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-performance-instances-unlimited-mode.html

  network_interfaces {
    description = "sut-net-${each.key}"
    associate_public_ip_address = true
    delete_on_termination = true
    //network_interface_id //The ID of the network interface to attach.
    security_groups = var.vpc_ec2_instance_security_groups_ids
    //subnet_id - The VPC Subnet ID to associate.
  }

  placement {
    availability_zone = "${var.aws_region}${lookup(var.suts_attributes[each.key], "primary_az_suffix")}"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "launched-from-sut-lt-${each.key}"
      source = "iac_contOrc-autoscaling"
    }
  }

  tags = {
    source = "iac_contOrc-autoscaling"
  }

  lifecycle {
      create_before_destroy = true
  }

  depends_on = [var.aws_s3_bucket_object_sut_public_keys]
}

resource "aws_autoscaling_group" "sut" {
  for_each = var.suts_attributes

  name = "sut-asg-${each.key}"

  desired_capacity   = lookup(var.suts_attributes[each.key], "ec2_instance_autoscaling_desired_capacity")
  max_size           = lookup(var.suts_attributes[each.key], "ec2_instance_autoscaling_desired_capacity")
  min_size           = 1
  force_delete = true

  target_group_arns = [var.aws_lb_target_groups[each.key].arn]

  vpc_zone_identifier = lookup(var.suts_attributes[each.key], "public_subnet_ids")

  launch_template {
    id      = aws_launch_template.sut[each.key].id
    version = aws_launch_template.sut[each.key].latest_version
  }

  tags = [
    { 
      key = "source"
      value = "iac-contOrc-autoscaling"
      propagate_at_launch = true
    }
  ]
}
