variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-2"
}
variable "instance_count" {
  default = "8"
}
variable "instance_name" {
  default = "I'm A Web Server"
}