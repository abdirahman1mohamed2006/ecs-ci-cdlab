# FRONTEND BUILD
FROM node:20-alpine AS frontend-build
WORKDIR /app/memos/web

COPY app/memos/web/package.json app/memos/web/pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install --frozen-lockfile

COPY app/memos/web/ ./
RUN pnpm run build


# BACKEND BUILD
FROM golang:1.26.1-alpine3.22 AS backend-build
WORKDIR /app/memos

RUN apk add --no-cache git ca-certificates

COPY app/memos/go.mod app/memos/go.sum ./
RUN go mod download

COPY app/memos/ ./

# copy built frontend into backend static files path
COPY --from=frontend-build /app/memos/web/dist ./server/router/frontend/dist

RUN go build -ldflags="-s -w" -o /out/memos ./cmd/memos


# RUNTIME
FROM alpine:3.20
WORKDIR /usr/local/memos

RUN apk add --no-cache ca-certificates \
  && addgroup -S memos \
  && adduser -S -G memos -u 10001 memos

COPY --from=backend-build /out/memos ./memos

RUN mkdir -p /var/opt/memos \
  && chown -R memos:memos /usr/local/memos /var/opt/memos \
  && chmod 500 ./memos

USER memos

ENV MEMOS_MODE=prod
ENV MEMOS_PORT=5230

EXPOSE 5230

CMD ["./memos", "--data", "/var/opt/memos"]