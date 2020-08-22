resource "aws_ecr_repository" "sut" {
  for_each = var.suts_attributes

  name                 = "suts/${each.value.name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    source = "iac-static-repository"
  }
}

