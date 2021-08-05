
output "ec2_machines_id" {
  value = aws_instance.web-nginx.*.id
}

output "ec2_machines_network_interface" {
  value = aws_instance.web-nginx.*.network_interface
}

output "ec2_machines_arn" {
  value = aws_instance.web-nginx.*.arn
}
output "instance_name" {
  value       = var.instance_name
}


output "address" {
  value = aws_elb.web-nginx.dns_name
}