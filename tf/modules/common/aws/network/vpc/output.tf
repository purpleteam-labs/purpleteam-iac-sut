output "vpc_id_default" {
  value = "${aws_default_vpc.default.id}"
  description = "The id of the default vpc."
  sensitive = false  
}

output "default_network_acl_id_of_default_vpc" {
  value = "${aws_default_vpc.default.default_network_acl_id}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
  description = "The id of the vpc."
  sensitive = false
}

output "default_network_acl_id_of_main_vpc" {
  value = "${aws_vpc.main.default_network_acl_id}"
  sensitive = false
}
