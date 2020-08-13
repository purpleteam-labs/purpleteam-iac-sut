resource "aws_default_vpc" "default" {}

resource "aws_vpc" "main" {
  cidr_block = var.cidr

  // Needs to be true if supporing private hosted zones in Route53, which is required by ECS Service Discovery.
  // Doc: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#vpc-dns-updating
  // Doc: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html
  // We don't need it enabled.
  enable_dns_support = true // Default: true.
  enable_dns_hostnames = true // Default: false.

  tags = var.vpc_tags
}
