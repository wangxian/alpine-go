FROM alpine:3.6

ENV GOLANG_VERSION 1.10.3
ENV GOLANG_SRC_URL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
ENV GOLANG_SRC_SHA256 5f5dea2447e7dcfdc50fa6b94c512e58bfba5673c039259fd843f688

ENV GOLANG_BOOTSTRAP_URL https://storage.googleapis.com/golang/go1.4-bootstrap-20161024.tar.gz
ENV GOLANG_BOOTSTRAP_SHA1 47e02e41aa99dea899b65ebf7b50ec706141be8c

RUN set -ex \
  && apk add --no-cache --virtual .build-deps \
    bash \
    ca-certificates \
    gcc \
    musl-dev \
    openssl \
  \
  && mkdir -p /usr/local/bootstrap \
  && wget -q "$GOLANG_BOOTSTRAP_URL" -O golang.tar.gz \
  && echo "$GOLANG_BOOTSTRAP_SHA1  golang.tar.gz" | sha1sum -c - \
  && tar -C /usr/local/bootstrap -xzf golang.tar.gz \
  && rm golang.tar.gz \
  && cd /usr/local/bootstrap/go/src \
  && sh ./make.bash \
  && export GOROOT_BOOTSTRAP=/usr/local/bootstrap/go \
  \
  && wget -q "$GOLANG_SRC_URL" -O golang.tar.gz \
  && echo "$GOLANG_SRC_SHA256  golang.tar.gz" | sha256sum -c - \
  && tar -C /usr/local -xzf golang.tar.gz \
  && rm golang.tar.gz \
  && cd /usr/local/go/src \
  && ./make.bash \
  \
  && echo "hosts: files dns" > /etc/nsswitch.conf \
  && rm -rf /usr/local/bootstrap /usr/local/go/pkg/bootstrap \
  && apk del .build-deps

# 1:fix tzdata timezone alpine
RUN apk add --no-cache curl tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata

# 2:modify
ENV GOPATH /app
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH