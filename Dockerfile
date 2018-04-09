FROM golang:alpine AS build-env
ADD . /go/src/hello-app
RUN apk add --no-cache git mercurial \
    && go get github.com/kataras/iris \
    && apk del git mercurial
RUN go install hello-app

FROM alpine:latest
COPY --from=build-env /go/bin/hello-app .
COPY --from=build-env /go/src/hello-app/views/hello.html ./views/hello.html
ENV PORT 8080
CMD ["./hello-app"]
