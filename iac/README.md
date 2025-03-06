# Terraform
https://developer.hashicorp.com/terraform/docs

## コマンド
```
terraform plan -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars
terraform destroy
```

```
terraform output -raw private_key_pem > ~/.ssh/next-ec2-sample-app-key.pem
chmod 600 ~/.ssh/next-ec2-sample-app-key.pem
```

```
terraform output ec2_public_ip
ssh -i ~/.ssh/next-ec2-sample-app-key.pem ec2-user@XX.XX.XX.XX
```

## 想定している構成
```
./iac/                            # IaC（Infrastructure as Code）管理用
├── terraform/                    # Terraform 管理ディレクトリ
│   ├── main.tf                   # 主要なリソースの定義（全体管理用）
│   ├── providers.tf              # AWS プロバイダの設定
│   ├── variables.tf              # 変数の定義
│   ├── outputs.tf                # 出力の定義
│   ├── vpc.tf                    # VPCの設定
│   ├── terraform.tfvars          # 環境ごとの変数（Git管理対象外）
│   ├── terraform.tfstate         # 状態管理ファイル（Git管理対象外）
│   ├── modules/                  # モジュール管理（各コンポーネントごとに分離）
│   │   ├── ec2/                  # EC2 のモジュール
│   │   │   ├── main.tf           # EC2 の定義
│   │   │   ├── key_pair.tf       # EC2 のキーペア
│   │   │   ├── security_group.tf # セキュリティグループの設定
│   │   │   ├── variables.tf      # 変数定義
│   │   │   ├── outputs.tf        # 出力定義
│   │   │   └── security.tf       # セキュリティグループ設定
│   │   ├── rds/                  # RDS のモジュール
│   │   │   ├── main.tf           # RDS の定義
│   │   │   ├── variables.tf      # 変数定義
│   │   │   ├── outputs.tf        # 出力定義
│   │   │   └── security.tf       # セキュリティグループ設定
│   │   ├── cognito/              # Cognito のモジュール
│   │   │   ├── main.tf           # Cognito の定義
│   │   │   ├── variables.tf      # 変数定義
│   │   │   ├── outputs.tf        # 出力定義
│   │   ├── s3/                   # S3 のモジュール
│   │   │   ├── main.tf           # S3 の定義
│   │   │   ├── variables.tf      # 変数定義
│   │   │   ├── outputs.tf        # 出力定義
│   ├── environments/             # 環境ごとの変数設定
│   │   ├── dev.tfvars            # 開発環境の変数
│   │   ├── staging.tfvars        # ステージング環境の変数
│   │   ├── prod.tfvars           # 本番環境の変数
│   ├── .gitignore                # `.tfstate` や `.tfvars` を除外
└── README.md                     # IaC のドキュメント
```