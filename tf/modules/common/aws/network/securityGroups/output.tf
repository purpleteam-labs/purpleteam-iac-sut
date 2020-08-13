// Security Groups for ECS instances.
output "sg_ssh_id" {
  value = aws_security_group.ssh_access_list.id
}

output "sg_sut_id" {
  value = aws_security_group.purpleteam_sut.id
}
