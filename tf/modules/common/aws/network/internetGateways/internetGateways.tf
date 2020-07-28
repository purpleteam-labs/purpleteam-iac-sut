resource "aws_internet_gateway" "pt-igw" {
  vpc_id = var.vpc_id

  tags = var.igw_tags
}
