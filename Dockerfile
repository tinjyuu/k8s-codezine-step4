FROM golang:1.9.2-alpine3.6

ADD ./server.go ./
RUN go build -o server
CMD ["/go/server"]