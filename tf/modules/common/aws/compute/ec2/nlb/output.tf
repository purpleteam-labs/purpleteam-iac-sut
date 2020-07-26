output "aws_lb_target_groups" {
  value = aws_lb_target_group.sut
  description = "The SUT specific lb target groups."
  sensitive = false
}

output "aws_lb_name" {
  value = aws_lb.pt.name
}

output "aws_lb_arn" {
  value = aws_lb.pt.arn
}

output "aws_lb_dns_name" {
  value = aws_lb.pt.dns_name
}
