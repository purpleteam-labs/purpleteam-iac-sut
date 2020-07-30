resource "aws_ssm_parameter" "pt" {
  for_each = var.ssm_parameters
  
  name  = each.key
  type  = var.ssm_parameters[each.key].type
  value = var.ssm_parameters[each.key].value
  description = var.ssm_parameters[each.key].description
  tags = var.ssm_parameters[each.key].tags
}

