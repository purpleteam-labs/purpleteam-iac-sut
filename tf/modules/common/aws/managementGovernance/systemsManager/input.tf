variable "ssm_parameters" {
  type = map(object({
    type = string
    value = string
    description = string
    tags = map(string)
  }))
}

