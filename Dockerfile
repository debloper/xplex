# ============== #
# STAGE 0: build #
# ============== #

FROM debian:trixie-slim AS build

# Package Information
LABEL container="xplex"
LABEL maintainer="Soumya Deb <debloper@gmail.com>"

# Update the environment
RUN apt update && apt install -y gcc g++ perl-modules make wget libsrt-openssl-dev

# Source package versions
ENV v_NGINX=1.29.1
ENV vm_OSSL=3.5.0
ENV vm_PCRE=10.46
ENV vm_RTMP=1.2.2
ENV vm_SRTP=1.1
ENV vm_ZLIB=1.3.1

# Source packages to be built
ENV SRC_NGINX=https://nginx.org/download/nginx-${v_NGINX}.tar.gz
ENV MODULE_SRC_OSSL=https://github.com/openssl/openssl/releases/download/openssl-${vm_OSSL}/openssl-${vm_OSSL}.tar.gz
ENV MODULE_SRC_PCRE=https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${vm_PCRE}/pcre2-${vm_PCRE}.tar.gz
ENV MODULE_SRC_RTMP=https://github.com/arut/nginx-rtmp-module/archive/v${vm_RTMP}.tar.gz
ENV MODULE_SRC_SRTP=https://github.com/kaltura/nginx-srt-module/archive/refs/tags/v${vm_SRTP}.tar.gz
ENV MODULE_SRC_ZLIB=https://zlib.net/fossils/zlib-${vm_ZLIB}.tar.gz

# Create a temporary build directory
WORKDIR /tmp/xplex

# Download the source archives
RUN wget ${SRC_NGINX} && \
    wget ${MODULE_SRC_OSSL} && \
    wget ${MODULE_SRC_PCRE} && \
    wget ${MODULE_SRC_RTMP} && \
    wget ${MODULE_SRC_SRTP} && \
    wget ${MODULE_SRC_ZLIB}

# Extract the source archives
RUN cat *.tar.gz | tar -izxvf -

# Switch to nginx source path
WORKDIR /tmp/xplex/nginx-${v_NGINX}

# Configure nginx source with modules
RUN ./configure \
    --with-openssl=../openssl-${vm_OSSL} \
    --with-pcre=../pcre2-${vm_PCRE} \
    --with-zlib=../zlib-${vm_ZLIB} \
    --add-module=../nginx-rtmp-module-${vm_RTMP} \
    --add-module=../nginx-srt-module-${vm_SRTP} \
    --with-stream --with-threads

# Build & install nginx
RUN make -j"$(nproc)" && make install && strip /usr/local/nginx/sbin/nginx


# ============== #
# STAGE 1: nginx #
# ============== #
FROM debian:trixie-slim AS nginx

## Transplant nginx
COPY --from=build /usr/local/nginx /usr/local/nginx

# Start container with daemon mode off to prevent halting
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]


# ============== #
# STAGE 2: xplex #
# ============== #
FROM node:slim AS xplex

## Transplant nginx & install custom configs for xplex
COPY --from=build /usr/local/nginx /usr/local/nginx
COPY conf/*.conf /usr/local/nginx/conf/

WORKDIR /xplex

# Install packages & start xplex HQ
COPY app/package.json ./
RUN npm i
COPY app ./

# Inject the application script
COPY xplex.sh ./

# BAM!
CMD ["./xplex.sh"]
