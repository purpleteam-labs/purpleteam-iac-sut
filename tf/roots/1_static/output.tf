// IAM instance profile used for EC2 Launch Templates.
output "ecs_instance_profile" {
  value = module.eC2RoleForLaunchingEC2Instances.ecs_instance_profile
  sensitive = true
}
