FROM golang:latest as builder

WORKDIR /app
RUN git clone --branch master --depth 1 https://github.com/dulanw/acme-dns-proxy.git .
RUN go mod tidy

WORKDIR /app/cmd
RUN CGO_ENABLED=0 GOOS=linux go build -o ./acme .


FROM alpine:latest

COPY --from=builder /app/cmd/acme /usr/bin/acme
CMD ["acme", "--config", "/etc/acme/config.yml"]
