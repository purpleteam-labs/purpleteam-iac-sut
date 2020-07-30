variable "retention_in_days" { type = number }
variable "sut_log_group_values" {
  type = map(object({
    log_group_name = string
    retention_in_days = number
  }))
}

