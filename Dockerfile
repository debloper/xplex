# ============== #
# STAGE 0: build #
# ============== #

FROM debian:bookworm-slim AS build

# Package Information
LABEL container="xplex"
LABEL maintainer="Soumya Deb <debloper@gmail.com>"

# Source package versions
ENV v_NGINX=1.26.1
ENV vm_OSSL=1.1.1w
ENV vm_PCRE=8.45
ENV vm_RTMP=1.2.2
ENV vm_ZLIB=1.3.1

# Source packages to be built
ENV SRC_NGINX=https://nginx.org/download/nginx-${v_NGINX}.tar.gz
ENV MODULE_SRC_OSSL=https://www.openssl.org/source/openssl-${vm_OSSL}.tar.gz
ENV MODULE_SRC_PCRE=https://sourceforge.net/projects/pcre/files/pcre/${vm_PCRE}/pcre-${vm_PCRE}.tar.gz
ENV MODULE_SRC_RTMP=https://github.com/arut/nginx-rtmp-module/archive/v${vm_RTMP}.tar.gz
ENV MODULE_SRC_ZLIB=https://zlib.net/fossils/zlib-${vm_ZLIB}.tar.gz

# Update the environment
RUN apt-get update && apt-get install -y gcc g++ perl-modules make wget

# Create a temporary build directory
WORKDIR /tmp/xplex

# Download the source archives
RUN wget ${SRC_NGINX} && \
    wget ${MODULE_SRC_OSSL} && \
    wget ${MODULE_SRC_PCRE} && \
    wget ${MODULE_SRC_RTMP} && \
    wget ${MODULE_SRC_ZLIB}

# Extract the source archives
RUN cat *.tar.gz | tar -izxvf -

# Switch to nginx source path
WORKDIR /tmp/xplex/nginx-${v_NGINX}

# Configure nginx source with modules
RUN ./configure \
    --with-openssl=../openssl-${vm_OSSL} \
    --with-pcre=../pcre-${vm_PCRE} \
    --with-zlib=../zlib-${vm_ZLIB} \
    --add-module=../nginx-rtmp-module-${vm_RTMP}

# Build & install nginx
RUN make
RUN make install


# ============== #
# STAGE 1: nginx #
# ============== #

FROM debian:bookworm-slim AS nginx

## Transplant nginx
COPY --from=build /usr/local/nginx /usr/local/nginx

# Start container with daemon mode off to prevent halting
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]


# ============== #
# STAGE 2: xplex #
# ============== #

FROM node:slim AS xplex

## Transplant nginx
COPY --from=build /usr/local/nginx /usr/local/nginx

# Install custom modular nginx configs for xplex
COPY conf/full/*.conf /usr/local/nginx/conf/

# Install xplex HQ app sources
COPY app ./app

# Inject the application script
COPY setup/full.sh ./

# BAM!
CMD ["./full.sh"]
