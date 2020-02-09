FROM alpine:3.11.0 as builder

RUN apk add --update --no-cache \
    autoconf \
    automake \
    build-base \
    libtool \
    git \
    pkgconfig

RUN git clone https://github.com/fukuchi/libqrencode.git \
 && cd libqrencode \
 && ./autogen.sh \
 && ./configure \
 && make \
 && make install

# Let's create the actual image that will be run

FROM cyphernode/alpine-glibc-base:v3.11.0_2.29-0

COPY --from=builder /usr/local/bin/qrencode /usr/local/bin/
COPY --from=builder /usr/local/lib/libqrencode.so.4.1.0 /usr/local/lib/libqrencode.so.4

