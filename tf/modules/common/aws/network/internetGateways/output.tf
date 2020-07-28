output "gw_id" {
  value = aws_internet_gateway.pt-igw.id
  description = "the iD of the Internet Gateway"
  sensitive = false
}
