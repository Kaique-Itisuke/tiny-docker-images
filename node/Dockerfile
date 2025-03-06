ARG NODE_VERSION=22.14.0
ARG DISTRO_VERSION=slim
ARG IMAGE_TAG=${NODE_VERSION}-${DISTRO_VERSION}

FROM node:${IMAGE_TAG} AS builder

WORKDIR /app

COPY tsconfig.json .

COPY package*.json .

RUN npm ci

COPY ./src ./src

RUN npm run build

RUN npm prune --production

FROM gcr.io/distroless/nodejs22-debian12:nonroot AS runner

COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/dist /app

WORKDIR /app

EXPOSE 8080

CMD ["main.js"]