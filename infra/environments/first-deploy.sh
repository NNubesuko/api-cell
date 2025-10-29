#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
INFRA_DIR=$(dirname "${SCRIPT_DIR}")

# 変数（必要に応じて環境変数で上書き可能）
PROJECT_NAME=${PROJECT_NAME:=<PROJECT_NAME>}
ENV=${ENV:=<ENV>}
AWS_REGION=${AWS_REGION:=ap-northeast-1}

BACKEND_FILE="environments/${ENV}.backend.hcl"
TFVARS_FILE="environments/${ENV}.tfvars"

cd "${INFRA_DIR}"
echo "変数定義"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REPO="${PROJECT_NAME}-${ENV}-ecr"
REPO_URL="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO}"

echo "----- 初回デプロイ開始 プロジェクト：${PROJECT_NAME} 環境：${ENV} -----"

exec_terraform() {
  local backend_file=$1
  local tfvars_file=$2
  shift 2

  echo "Terraform init"
  terraform init -reconfigure -backend-config="${backend_file}"

  echo "Terraform plan"
  terraform plan -var-file="${tfvars_file}"

  echo "Terraform apply"
  terraform apply -var-file="${tfvars_file}" "$@"
}

echo "ECR と IAM の初期デプロイを行いLambdaのイメージアタッチ時にエラーが発生しないように対策"
exec_terraform "${BACKEND_FILE}" "${TFVARS_FILE}" -target=module.ecr -target=module.iam

echo "ECR ログイン"
aws ecr get-login-password --region "${AWS_REGION}" \
  | docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "公式 Lambda ベースイメージを取得して :dummy と :latest を付けてプッシュ"
docker pull public.ecr.aws/lambda/nodejs:20 > /dev/null
for tag in dummy latest; do
  docker tag public.ecr.aws/lambda/nodejs:20 "${REPO_URL}:${tag}"
  docker push "${REPO_URL}:${tag}"
done

echo "全体のリソースをデプロイ"
exec_terraform "${BACKEND_FILE}" "${TFVARS_FILE}"

echo "----- 初回デプロイ完了 プロジェクト：${PROJECT_NAME} 環境：${ENV} -----"
