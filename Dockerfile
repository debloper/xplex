# ============== #
# STAGE 0: Build #
# ============== #

FROM debian:stretch-slim as builder

# Package Information
LABEL version="0.1.0"
LABEL container="xplex"
LABEL maintainer="Soumya Deb <debloper@gmail.com>"

# Source package versions
ENV v_NGINX=1.15.8
ENV vm_OSSL=1.1.1a
ENV vm_PCRE=8.42
ENV vm_RTMP=1.2.1
ENV vm_ZLIB=1.2.11

# Source packages to be built
ENV SRC_NGINX=https://nginx.org/download/nginx-${v_NGINX}.tar.gz
ENV MODULE_SRC_OSSL=https://www.openssl.org/source/openssl-${vm_OSSL}.tar.gz
ENV MODULE_SRC_PCRE=https://ftp.pcre.org/pub/pcre/pcre-${vm_PCRE}.tar.gz
ENV MODULE_SRC_RTMP=https://github.com/arut/nginx-rtmp-module/archive/v${vm_RTMP}.tar.gz
ENV MODULE_SRC_ZLIB=http://zlib.net/zlib-${vm_ZLIB}.tar.gz

# Update the environment
RUN apt-get update && \
    apt-get install -y gcc g++ perl-modules make wget

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
RUN mv nginx-${v_NGINX} nginx
WORKDIR nginx

# Configure nginx source with modules
RUN ./configure --with-openssl=../openssl-${vm_OSSL} --with-pcre=../pcre-${vm_PCRE} --with-zlib=../zlib-${vm_ZLIB} --add-module=../nginx-rtmp-module-${vm_RTMP}

# Build and install nginx
RUN make


# ============= #
# STAGE 1: Lean #
# ============= #

FROM debian:stretch-slim as lean

# Installing Nginx, manually (to avoid dependency on make)
RUN mkdir -p  /usr/local/nginx \
              /usr/local/nginx/sbin \
              /usr/local/nginx/conf \
              /usr/local/nginx/logs

COPY --from=builder /tmp/xplex/nginx/objs/nginx /usr/local/nginx/sbin/nginx

COPY --from=builder /tmp/xplex/nginx/conf/mime.types \
                    /tmp/xplex/nginx/conf/fastcgi_params \
                    /tmp/xplex/nginx/conf/fastcgi.conf \
                    /tmp/xplex/nginx/conf/uwsgi_params \
                    /tmp/xplex/nginx/conf/scgi_params \
                    /usr/local/nginx/conf/

COPY --from=builder /tmp/xplex/nginx/html /usr/local/nginx/html

COPY conf/*.conf /usr/local/nginx/conf/
COPY setup/lean.sh ./

EXPOSE 80
EXPOSE 1935

CMD ./lean.sh

# ============= #
# STAGE 2: Full #
# ============= #

FROM node:latest as full

# Installing Nginx, manually (to avoid dependency on make)
RUN mkdir -p  /usr/local/nginx \
              /usr/local/nginx/sbin \
              /usr/local/nginx/conf \
              /usr/local/nginx/logs

COPY --from=builder /tmp/xplex/nginx/objs/nginx /usr/local/nginx/sbin/nginx

COPY --from=builder /tmp/xplex/nginx/conf/mime.types \
                    /tmp/xplex/nginx/conf/fastcgi_params \
                    /tmp/xplex/nginx/conf/fastcgi.conf \
                    /tmp/xplex/nginx/conf/uwsgi_params \
                    /tmp/xplex/nginx/conf/scgi_params \
                    /usr/local/nginx/conf/

COPY --from=builder /tmp/xplex/nginx/html /usr/local/nginx/html

COPY conf/*.conf /usr/local/nginx/conf/
COPY admin ./
COPY setup/full.sh ./

EXPOSE 80
EXPOSE 1935

CMD ./full.sh
