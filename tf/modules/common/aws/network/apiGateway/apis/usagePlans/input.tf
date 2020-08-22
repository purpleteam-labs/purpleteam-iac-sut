variable "api_id" { type = string }
variable "usage_plan_values" {
  description = "See top level module for definition."
}
// To specify dependency due to API Gateway's flaws.
variable "stages" {
  type = list(map(any))
}
