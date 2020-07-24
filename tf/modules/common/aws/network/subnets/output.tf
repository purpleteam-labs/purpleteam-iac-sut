output "pub_subnets" {
  value = aws_subnet.public.*
  description = "The public subnets."
  sensitive = false
}
