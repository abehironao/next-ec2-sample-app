resource "aws_security_group" "next_ec2_sample_app_security_group" {
  vpc_id      = var.vpc_id  # ルートから渡す
  name        = "next_ec2_sample_app_security_group"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SSH アクセス許可
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # HTTP アクセス許可
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # すべてのアウトバウンド通信を許可
  }
}