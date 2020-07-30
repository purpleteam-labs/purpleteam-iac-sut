variable "values" {
  type = map(object({
    log_group_name = string
    retention_in_days = number
  }))
}

