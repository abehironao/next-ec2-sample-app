output "next_ec2_sample_app_public_ip" {
  value = aws_instance.next_ec2_sample_app.public_ip
}

output "security_group_id" {
  value = aws_security_group.next_ec2_sample_app_security_group.id
}