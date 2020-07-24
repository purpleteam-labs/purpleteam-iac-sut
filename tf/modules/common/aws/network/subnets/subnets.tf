resource "aws_subnet" "public" {
  count = length(var.subnets_properties)
  vpc_id = var.vpc_id
  cidr_block = lookup(var.subnets_properties[count.index], "cidr")
  availability_zone = lookup(var.subnets_properties[count.index], "availability_zone")

  tags = {
    Name = lookup(var.subnets_properties[count.index], "name")
  }
}
