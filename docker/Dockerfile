FROM alpine:edge
RUN echo https://ids1024.com/alpine >> /etc/apk/repositories
RUN apk add --no-cache --allow-untrusted alpine-sdk nodejs npm cmake clang lld wabt cargo python
RUN echo "{\"allow_root\": true}" > ~/.bowerrc
