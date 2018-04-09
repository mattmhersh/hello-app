FROM golang:alpine AS build-env
ADD . /go/src/hello-app
RUN apk add --no-cache git mercurial \
    && go get github.com/kataras/iris \
    && apk del git mercurial
#RUN env GIT_TERMINAL_PROMPT=1
#RUN apk --no-cache add build-base git bzr mercurial gcc
#ENV D=/go/src/hello-app
#RUN go get -u github.com/golang/dep/cmd/dep
#RUN go get -u github.com/kataras/iris
# ENV PATH="${PATH}:/go/bin"
#RUN env
#ADD Gopkg.* $D/
#RUN cd $D && dep ensure --vendor-only
#ADD . $D
#RUN go get -u github.com/kataras/iris
RUN go install hello-app
#RUN cd $D && go build -o hello-app && cp hello-app /tmp/

FROM alpine:latest
#COPY --from=0 /go/bin/hello-app .
#WORKDIR /app
COPY --from=build-env /go/bin/hello-app .
COPY --from=build-env /go/src/hello-app/views/hello.html ./views/hello.html
ENV PORT 8080
CMD ["./hello-app"]
#ENTRYPOINT ["./hello-app"]
