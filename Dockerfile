# syntax=docker/dockerfile:1

FROM node:20-alpine AS base
WORKDIR /app
ENV CI=true

FROM base AS deps
# Build tools for native modules
RUN apk add --no-cache python3 make g++ libc6-compat
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM deps AS builder
COPY . .
# Provide safe defaults so build does not fail if config reads env at build time
ARG APP_KEYS=build,keys,not,used
ARG JWT_SECRET=build-secret
ARG ADMIN_JWT_SECRET=build-admin-secret
ARG API_TOKEN_SALT=build-api-salt
ARG TRANSFER_TOKEN_SALT=build-transfer-salt
ARG URL=http://localhost:1337
ENV NODE_ENV=production
RUN yarn build

FROM base AS runner
ENV NODE_ENV=production
ENV HOST=0.0.0.0
WORKDIR /app

# Copy runtime deps and built assets
COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/build ./build
COPY --from=builder /app/config ./config
COPY --from=builder /app/src ./src
COPY --from=builder /app/public ./public
COPY --from=builder /app/.strapi-updater.json ./.strapi-updater.json

EXPOSE 1337

# Run DB schema deploy then start Strapi
CMD ["sh","-c","yarn deploy && yarn start"]


