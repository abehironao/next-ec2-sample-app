resource "tls_private_key" "next_ec2_sample_app_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "next_ec2_sample_app_key" {
  key_name   = "next_ec2_sample_app_key"
  public_key = tls_private_key.next_ec2_sample_app_key.public_key_openssh
}

output "private_key_pem" {
  value     = tls_private_key.next_ec2_sample_app_key.private_key_pem
  sensitive = true
}
