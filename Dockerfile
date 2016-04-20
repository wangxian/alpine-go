FROM alpine:edge
MAINTAINER WangXian <xian366@126.com>

WORKDIR /app
COPY . .

RUN apk add --update curl go
RUN apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata
RUN rm /var/cache/apk/*

ENV GOPATH /app
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

EXPOSE 3000
CMD ["/bin/sh", "./startup.sh"]
