# API Cell

## 構成図
![構成図](https://github.com/NNubesuko/api-cell/blob/main/api-cell.drawio.png)

## 使い方

初期化(develop)

```bash
terraform init  -backend-config=environments/develop.backend.hcl
terraform plan  -var-file=environments/develop.tfvars
terraform apply -var-file=environments/develop.tfvars
```

環境変更

```bash
terraform init -reconfigure -backend-config=environments/staging.backend.hcl
terraform apply -var-file=environments/staging.tfvars
```

Makefileを使用した各操作

```bash
make init ENV=develop
make plan ENV=staging
make apply ENV=production
```