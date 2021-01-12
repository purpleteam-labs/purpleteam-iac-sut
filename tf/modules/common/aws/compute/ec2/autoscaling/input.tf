// Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

// This file is part of purpleteam.

// purpleteam is free software: you can redistribute it and/or modify
// it under the terms of the MIT License.

// purpleteam is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// MIT License for more details.

variable "aws_region" { 
  description = "AWS region in use."
  type = string
}
variable "ecs_image_id" {
  description = "The ECS optimised AMIs"
  type = map
}
variable "ecs_instance_profile" {
  type = string
}
variable "vpc_ec2_instance_security_groups_ids" {
  description = "Security Groups to be applied to EC2 instances"
  type = list(string)
}
variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."  
  type = map(object({
    instance_type = string
    public_subnet_ids = list(string)
    primary_az_suffix = string
    ec2_instance_autoscaling_desired_capacity = number
  }))
}

variable "aws_lb_target_groups" { type = map(any) }
variable "aws_s3_bucket_object_sut_public_keys" { type = map(any) }
