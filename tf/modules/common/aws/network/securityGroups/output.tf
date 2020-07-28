// Security Groups for ECS instances.
output "sg_ssh_id" {
  value = aws_security_group.ssh_access_list.id
}

output "sg_pt_id" {
  value = aws_security_group.purpleteam.id
}
