resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }
/*
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = "${aws_egress_only_internet_gateway.foo.id}"
  }
*/
  tags = { Name = "pt-rt-${var.aws_region}" }
}


resource "aws_route_table_association" "a" {
  count = length(var.public_and_2nd_mandatory_subnet_for_lb_subnet_ids)

  subnet_id      = var.public_and_2nd_mandatory_subnet_for_lb_subnet_ids[count.index]
  route_table_id = aws_route_table.rt.id
}

