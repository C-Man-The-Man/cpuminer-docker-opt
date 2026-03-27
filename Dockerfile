# syntax=docker/dockerfile:1.7-labs
FROM debian:bookworm-slim AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH

RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential automake autoconf libtool pkg-config \
    libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev zlib1g-dev \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN git clone --depth 1 https://github.com/JayDDee/cpuminer-opt.git .

RUN ./autogen.sh && \
    case "$TARGETARCH" in \
      amd64) CFLAGS="-O3 -march=x86-64-v3 -mtune=generic -fomit-frame-pointer" ;; \
      arm64) CFLAGS="-O3 -march=armv8-a -mtune=generic -fomit-frame-pointer" ;; \
      *) CFLAGS="-O3" ;; \
    esac && \
    ./configure --with-curl CFLAGS="$CFLAGS" && \
    make -j$(nproc) && \
    strip cpuminer

# ---------- RUNTIME ----------
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4 libjansson4 libssl3 libgmp10 ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd -r miner && useradd -r -g miner miner

COPY --from=builder /build/cpuminer /usr/local/bin/cpuminer
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

USER miner
WORKDIR /home/miner

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
