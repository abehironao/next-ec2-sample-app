#  最新の Amazon Linux 2023 の AMI を自動取得する
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }
}

resource "aws_instance" "next_ec2_sample_app" {
  instance_type   = var.instance_type
  ami             = data.aws_ami.latest_amazon_linux.id
  key_name        = aws_key_pair.next_ec2_sample_app_key.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.next_ec2_sample_app_security_group.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y

    # Git インストール
    sudo yum install -y git

    # Nginx のインストール & 設定
    sudo yum install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx

    # Nginx の設定
    echo 'server {
      listen 80;
      server_name _;
      location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      }
    }' | sudo tee /etc/nginx/conf.d/next-ec2-sample-app.conf

    sudo systemctl restart nginx

    # Node.js インストール (NVM)
    sudo -u ec2-user bash -c "
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash &&
      source ~/.bashrc &&
      nvm install --lts
    "

    # Next.js アプリのセットアップ
    cd /home/ec2-user
    sudo -u ec2-user bash -c "
      git clone https://github.com/abehironao/next-ec2-sample-app.git &&
      cd next-ec2-sample-app &&
      source ~/.bashrc &&
      npm install &&
      npm run build
    "

    # PM2 のインストール & Next.js の起動
    sudo -u ec2-user bash -c "
      source ~/.bashrc &&
      nvm use --lts &&
      npm install -g pm2 &&
      cd /home/ec2-user/next-ec2-sample-app &&
      pm2 start npm --name \"next-ec2-sample-app\" -- start &&
      pm2 save &&
      pm2 startup systemd
    "
    # pm2 startup systemd で出力されたコマンドを実行する必要がある TODO: ここがうまくいっているか自身がない
    sudo env PATH=$PATH:/home/ec2-user/.nvm/versions/node/v22.14.0/bin /home/ec2-user/.nvm/versions/node/v22.14.0/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user
    sudo systemctl enable pm2-ec2-user
  EOF

  tags = {
    Name = "Next.js Server"
  }
}