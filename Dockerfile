FROM debian:stretch-slim
SHELL ["/bin/bash", "-c"]
### Install packages for Debian-based OS ###

RUN apt-get update \
    && apt-get install -yq \
    autoconf-archive \
    bison build-essential \
    cmake \
    curl \
    flex \
    git \
    gperf \
    joe \
    libboost-all-dev \
    libcap-dev \
    libdouble-conversion-dev \
    libevent-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libkrb5-dev \
    libnuma-dev \
    libsasl2-dev \
    libsnappy-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    netcat-openbsd \
    pkg-config \
    sudo \
    unzip \
    wget \
    zlib1g-dev\
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

### Check out facebook/folly, workdir folly ###

WORKDIR '/home'
RUN git clone https://github.com/facebook/folly \
    && cd folly \
    && git checkout 7897c65f48f8186e23eef14ed8b08381311759bc \
    && cd build \
    && CXXFLAGS="$CXXFLAGS -fPIC " CFLAGS="$CFLAGS -fPIC " cmake -D'BUILD_SHARED_LIBS'='ON' '..' \
    && make -j$[$(nproc) + 1]  \
    && make install \
    && cd \
    && rm /home/folly/* -rf

### Check out facebook/wangle, workdir wangle/build ###

WORKDIR '/home'
RUN git clone https://github.com/facebook/wangle \
    && cd wangle \
    && git checkout 31490ee0ce2c271fe56582a1a8d4aa15a7dab774 \
    && mkdir /home/wangle/wangle/build \
    && cd /home/wangle/wangle/build \
    && CXXFLAGS="$CXXFLAGS -fPIC " CFLAGS="$CFLAGS -fPIC " cmake -D'BUILD_SHARED_LIBS'='ON'  .. \
    && make -j$[$(nproc) + 1] \
    && make install \
    && cd \
    && rm /home/wangle/* -rf

### Check out facebook/proxygen, workdir proxygen ###

WORKDIR '/home'
RUN git clone https://github.com/facebook/proxygen.git \
    && cd proxygen \
    && git checkout v2018.05.07.00 \
    && cd /home/proxygen/proxygen \
    && autoreconf -ivf \
    && ./configure \
    && make -j$[$(nproc) + 1] \
    && make install \
    && LD_LIBRARY_PATH=/usr/local/lib make check \
    && cd \
    && rm /home/proxygen -rf

CMD ["bash"]