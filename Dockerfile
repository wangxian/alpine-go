FROM alpine:edge
MAINTAINER WangXian <xian366@126.com>

WORKDIR /app
COPY . .

RUN apk --update add git curl go && rm /var/cache/apk/*

ENV GOPATH /app
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

EXPOSE 3000
CMD ["/startup.sh"]
