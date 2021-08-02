
output "ec2_machines_id" {
  value = aws_instance.web-nginx.*.id
}

output "instance_name" {
  value       = var.instance_name
}

output "address for website" {
  value = aws_elb.web-nginx.dns_name
}
