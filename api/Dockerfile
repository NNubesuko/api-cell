FROM public.ecr.aws/docker/library/node:20-slim AS base
WORKDIR /app

# 1) Install deps with cache-friendly layer
FROM base AS deps
COPY package*.json ./
RUN npm ci

# 2) Build NestJS (TS -> JS in dist/)
FROM deps AS build
COPY . .
RUN npm run build

# 3) Runtime with AWS Lambda Web Adapter
FROM public.ecr.aws/docker/library/node:20-slim AS runner

# Add AWS Lambda Web Adapter extension
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.1 /lambda-adapter /opt/extensions/lambda-adapter

# 本番依存のみコピー
COPY --from=deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY package*.json ./

# 非 root 実行
USER node

# 推奨: 衝突しにくいポート (例: 7000)
ENV PORT=7000 \
    AWS_LWA_PORT=7000 \
    AWS_LWA_ENABLE_COMPRESSION=true \
    RUST_LOG=info

EXPOSE 7000

# NestJS アプリ起動
CMD ["node", "dist/main.js"]