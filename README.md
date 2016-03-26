# alpine-go
Alpine Linux-base Docker image with Golang


Application will start `./startup.sh` Automatically.

# build
```
docker build -t wangxian/alpine-go .
docker run -it --rm -p 80:3000 wangxian/alpine-go
```