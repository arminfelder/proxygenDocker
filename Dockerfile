FROM debian:latest

RUN apt-get update \
    && apt-get install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common -y \
    sudo \
    build-essential cmake libcurl4-gnutls-dev git libjsoncpp-dev \
    g++ \
    automake \
    autoconf \
    autoconf-archive \
    libtool \
    libboost-all-dev \
    libevent-dev \
    libdouble-conversion-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    liblz4-dev \
    liblzma-dev \
    libsnappy-dev \
    make \
    zlib1g-dev \
    binutils-dev \
    libjemalloc-dev \
    libssl-dev \
    pkg-config -y \
    wget \
    && apt-get clean

ENV CXXFLAGS "$CXXFLAGS"
ENV CFLAGS "$CFLAGS"
ENV MAKEFLAGS="-j$[$(nproc) + 1]"

RUN mkdir /proxygenSrc \
    && cd /proxygenSrc \
    && git clone https://github.com/facebook/proxygen.git \
    && cd proxygen/proxygen \
    && ./deps.sh \
    && ./reinstall.sh \
    && cd \
    && rm -r /proxygenSrc \
    && apt-get clean

CMD ["bash"]