FROM ubuntu:24.04
ARG COMMIT_TAG

RUN apt-get update && apt-get install -y git sudo lsb-release libfast-float-dev

WORKDIR /opt/
RUN git clone https://github.com/facebook/proxygen
WORKDIR /opt/proxygen/proxygen
RUN git checkout ${COMMIT_TAG}
RUN ./build.sh -j $(nproc)
RUN ./install.sh


FROM ubuntu:24.04

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get --no-install-recommends install -y libcap2 \
    libdouble-conversion3 \
    libevent-2.1-7 \
    libgflags2.2 \
    libgoogle-glog0v6t64 \
    libkrb5-3 \
    libpcre3 \
    libnuma1 \
    libsasl2-2 \
    libsnappy1v5 \
    libsqlite3-0 \
    liblz4-1 \
    liblzma5 \
    libssl3t64 \
    libjemalloc2 \
    libsodium23 && apt-get clean

RUN ldconfig
libssl