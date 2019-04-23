FROM debian:stretch-slim
SHELL ["/bin/bash", "-c"]
### Install packages for Debian-based OS ###

RUN apt-get update \
    && apt-get install -yq \
    autoconf-archive \
    bison \
    build-essential \
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
    libkrb5-dev \
    libpcre3-dev \
    libpthread-stubs0-dev \
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
    zlib1g-dev \
    gcc \
    g++ \
    libgtest-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean


### Check out facebook/folly, workdir folly ###
WORKDIR '/home'
RUN git clone http://github.com/google/glog.git google-glog \
    && cd google-glog \
    && ./autogen.sh \
    && ./configure \
    && make -j$[$(nproc) + 1] \
    && make install \
    && cd / \
    && rm /home/google-glog -rf

WORKDIR '/home'
RUN git clone http://github.com/gflags/gflags gflags-gflags \
    && cd gflags-gflags \
    && mkdir build \
    && cd build \
    && cmake configure .. -DBUILD_SHARED_LIBS=ON -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    && make -j$[$(nproc) + 1] \
    && make install \
    && cd / \
    && rm /home/google-gflags -rf

WORKDIR '/home'
RUN git clone https://github.com/facebook/folly \
    && cd folly \
    && git checkout c47ff43bbabadff7894fd3264fc0078686765a1d \
    && mkdir _build \
    && cd _build \
    && cmake configure .. -DBUILD_SHARED_LIBS=ON -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    && make -j$[$(nproc) + 1]  \
    && make install \
    && cd \
    && rm /home/folly/* -rf


### Check out jedisct1/libsodium, workdir . ###
WORKDIR '/home'
RUN git clone https://github.com/jedisct1/libsodium \
    && cd libsodium \
    && git checkout 'stable' \
    && ./configure \
    && make -j$[$(nproc) + 1] \
    && make check \
    && make install \
    && cd / \
    && rm /home/libsodium/* -rf


### Check out facebook/facebookincubator/fizz, workdir fizz ###

WORKDIR '/home'
RUN git clone https://github.com/facebookincubator/fizz \
    && cd fizz/fizz \
    && mkdir build_ \
    && cd build_  \
    && cmake .. \
    && make -j$[$(nproc) + 1] \
    && make install \
    && cd / \
    && rm /home/fizz/* -rf


### Check out facebook/wangle, workdir wangle/build ###

WORKDIR '/home'
RUN git clone https://github.com/google/googletest.git gtest \
    && cd gtest \
    && git checkout release-1.8.0 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j9 \
    && make install \
    && rm /home/gtest -rf

WORKDIR '/home'
RUN git clone https://github.com/facebook/wangle \
    && cd wangle \
    && git checkout 52ac74a45aebafc28e4a0b7ab3ae529a914d9ecf \
    && mkdir /home/wangle/wangle/build \
    && cd /home/wangle/wangle/build \
    && cmake .. \
    && make -j$[$(nproc) + 1] \
    && make install \
    && cd \
    && rm /home/wangle/* -rf

### Check out facebook/proxygen, workdir proxygen ###

WORKDIR '/home'
RUN git clone https://github.com/facebook/proxygen.git \
    && cd proxygen \
    && git checkout v2019.04.22.00 \
    && cd /home/proxygen/proxygen \
    && autoreconf -ivf \
    && ./configure \
    && make -j$[$(nproc) + 1] \
    && LD_LIBRARY_PATH=/usr/local/lib make check \
    && make install \
    && cd \
    && rm /home/proxygen -rf

CMD ["bash"]