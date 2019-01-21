# ============= #
# STAGE 0: Make #
# ============= #

FROM debian:stretch-slim as make

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

# Switch to NGINX source path
RUN mv nginx-${v_NGINX} nginx
WORKDIR nginx

# Configure NGINX source with modules
RUN ./configure \
    --with-openssl=../openssl-${vm_OSSL} \
    --with-pcre=../pcre-${vm_PCRE} \
    --with-zlib=../zlib-${vm_ZLIB} \
    --add-module=../nginx-rtmp-module-${vm_RTMP}

# Build NGINX
RUN make


# ============= #
# STAGE 1: Base #
# ============= #

# Re-initiating base image to avoid the bloats from `make` stage
FROM debian:stretch-slim as base

# Installing NGINX, manually (to avoid dependency on make)
# --------------------------------------------------------
## Creating necessary directory structure, to install files in
RUN mkdir -p  /usr/local/nginx \
              /usr/local/nginx/sbin \
              /usr/local/nginx/conf \
              /usr/local/nginx/logs

## Installing NGINX binary
COPY --from=make /tmp/xplex/nginx/objs/nginx /usr/local/nginx/sbin/nginx

## Installing common config & supporting files
COPY --from=make /tmp/xplex/nginx/conf/mime.types \
                    /tmp/xplex/nginx/conf/fastcgi_params \
                    /tmp/xplex/nginx/conf/fastcgi.conf \
                    /tmp/xplex/nginx/conf/uwsgi_params \
                    /tmp/xplex/nginx/conf/scgi_params \
                    /usr/local/nginx/conf/

# Mapping the default HTTP & RTMP port to be published
EXPOSE 80
EXPOSE 1935

## NGINX is now installed, but it has no main config file yet
## Child images are to put in their own config & start server
## In follow up 2 stages this image is used as the base image


# ============= #
# STAGE 2: Lean #
# ============= #

# Using `base` image from stage 1
FROM base as lean

# Install NGINX default contents
COPY --from=make /tmp/xplex/nginx/html /usr/local/nginx/html

# Install NGINX default config
COPY --from=make /tmp/xplex/nginx/conf/nginx.conf /usr/local/nginx/conf/

# Start the server with daemon mode off to prevent halting the container
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]


# ============= #
# STAGE 3: Lite #
# ============= #

# Using `base` image from stage 1
FROM base as lite

# Install NGINX default contents
COPY --from=make /tmp/xplex/nginx/html /usr/local/nginx/html

# Installing custom xplex config with modular HTTP+RTMP contexts
COPY conf/lite/*.conf /usr/local/nginx/conf/

# Injecting main executable: set up NGINX config & start servers
COPY setup/lite.sh ./

# And, voila!
CMD ./lite.sh


# ============= #
# STAGE 4: Full #
# ============= #

# We're using NodeJS official image as the base image for `full`
# node:slim uses very same debian:stretch-slim as the base image
# So, the NGINX we built in `make` can be used as it's same arch
FROM node:slim as full
# i.e. same base crust, with extra toppings, salads & olive oils

# Installing NGINX manually again - as we can't use `base` stage
RUN mkdir -p  /usr/local/nginx \
              /usr/local/nginx/sbin \
              /usr/local/nginx/conf \
              /usr/local/nginx/logs

COPY --from=make /tmp/xplex/nginx/objs/nginx /usr/local/nginx/sbin/nginx

COPY --from=make /tmp/xplex/nginx/conf/mime.types \
                    /tmp/xplex/nginx/conf/fastcgi_params \
                    /tmp/xplex/nginx/conf/fastcgi.conf \
                    /tmp/xplex/nginx/conf/uwsgi_params \
                    /tmp/xplex/nginx/conf/scgi_params \
                    /usr/local/nginx/conf/

COPY --from=make /tmp/xplex/nginx/html /usr/local/nginx/html
# Done installing NGINX (without config), like upto `base` stage

# Then installing modular xplex configs like in the `lite` stage
COPY conf/full/*.conf /usr/local/nginx/conf/

# Copying in the xplex HQ app sources
COPY app ./app

# Injecting main executable: set up NGINX config & start servers
COPY setup/full.sh ./

# Mapping the default HTTP & RTMP port to be published
EXPOSE 80
EXPOSE 1935

# BAM!
CMD ./full.sh
