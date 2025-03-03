provider "aws" {
  region = "ap-northeast-1"
}

# デフォルト VPC の取得
data "aws_vpc" "default" {
  default = true
}

# デフォルト VPC のサブネットを取得
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "default" {
  id = tolist(data.aws_subnets.default.ids)[0]  # 最初のサブネットを選択
}

module "ec2" {
  source = "./modules/ec2"
  instance_type     = var.instance_type
  vpc_id            = data.aws_vpc.default.id
  subnet_id         = data.aws_subnet.default.id
  security_group_id = module.ec2.security_group_id
}

output "ec2_public_ip" {
  value = module.ec2.next_ec2_sample_app_public_ip
}

output "private_key_pem" {
  value     = module.ec2.private_key_pem
  sensitive = true
}

# module "rds" {
#   source         = "./modules/rds"
#   db_name        = var.db_name
#   instance_class = var.instance_class
# }

# module "cognito" {
#   source         = "./modules/cognito"
#   user_pool_name = var.user_pool_name
# }

# module "s3" {
#   source      = "./modules/s3"
#   bucket_name = var.bucket_name
# }