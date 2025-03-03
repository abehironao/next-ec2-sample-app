#  最新の Amazon Linux 2 の AMI を自動取得する
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "next_ec2_sample_app" {
  instance_type   = var.instance_type
  ami             = data.aws_ami.latest_amazon_linux.id
  key_name        = aws_key_pair.next_ec2_sample_app_key.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.next_ec2_sample_app_security_group.id]
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.this.key_name

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y

    # Node.js インストール: https://docs.aws.amazon.com/ja_jp/sdk-for-javascript/v3/developer-guide/setting-up-node-on-ec2-instance.html
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    source ~/.bashrc
    nvm install --lts

    # Git インストール
    sudo yum install -y git

    # Nginx のインストール & 設定
    sudo yum install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx

    # Nginx の設定
    echo 'server {
      listen 80;
      location / {
        proxy_pass http://localhost:3331;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      }
    }' | sudo tee /etc/nginx/conf.d/next-ec2-sample-app.conf

    sudo systemctl restart nginx

    # Next.js アプリのセットアップ
    cd /home/ec2-user
    git clone https://github.com/your-repo/next-ec2-sample-app.git
    cd next-ec2-sample-app
    npm install
    npm run build

    # PM2 のインストール & Next.js の起動
    sudo npm install -g pm2
    pm2 start npm --name "next-ec2-sample-app" -- start
    pm2 save
    pm2 startup systemd
    sudo systemctl enable pm2-ec2-user
  EOF

  tags = {
    Name = "Next.js Server"
  }
}