FROM golang:1.12 AS builder
LABEL name="psychopenguin/noderecycler" \
    version=3.0.0
RUN apt-get update && apt-get install -y upx && apt-get clean
WORKDIR /noderecycler
COPY go.mod go.sum .
RUN go get -u .
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -v -o noderecycler main.go
RUN upx --best noderecycler

FROM busybox:1
COPY --from=builder ./noderecycler .
CMD ["./noderecycler"]
