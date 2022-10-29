FROM golang:1.19
RUN mkdir /build
WORKDIR /build
COPY . .

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o server cmd/server/main.go

FROM alpine:3.10
ARG 8080
RUN apk --no-cache add ca-certificates
WORKDIR /

COPY --from=0 /build/server server

## config for timezone
COPY --from=0 /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=0 /build/docker-entrypoint.sh /
EXPOSE 8080

ENTRYPOINT [ "/server" ]