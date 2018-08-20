FROM alpine:edge

RUN apk add --update curl go bash musl-dev \
 && rm /var/cache/apk/*

# 1:fix tzdata timezone alpine
RUN apk add --no-cache curl tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata

# 2:modify
ENV GOPATH /app
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH
