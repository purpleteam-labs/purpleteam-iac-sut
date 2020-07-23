// IAM instance profile used for EC2 Launch Templates.
output "ecs_instance_profile" {
  value = module.eC2RoleForLaunchingEC2Instances.ecs_instance_profile
  sensitive = true
}

// IAM role used for the ECS Services to make calls to the load balancer on our behalf.
output "ecs_service_role" {
  value = module.eCSRoleForECSServiceToCallELB.ecs_service_role
  sensitive = true
}
