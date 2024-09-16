FROM golang:alpine3.20 as builder
WORKDIR /usr/src/app
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
RUN go build -v -o api ./cmd/api

FROM golang:alpine3.20
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/api ./
ENTRYPOINT ["./api"]
EXPOSE 8081