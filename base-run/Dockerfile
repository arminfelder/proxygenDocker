FROM ubuntu:18.04
ARG COMMIT_TAG

RUN apt-get update && apt-get install -y git sudo

WORKDIR /opt/
RUN git clone https://github.com/facebook/proxygen
WORKDIR /opt/proxygen/proxygen
RUN git checkout ${COMMIT_TAG}
RUN ./build.sh -j $(nproc)
RUN ./install.sh


FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get --no-install-recommends install -y libcap2 \
    libdouble-conversion1 \
    libevent-2.1-6 \
    libgflags2.2 \
    libgoogle-glog0v5 \
    libkrb5-3 \
    libpcre3 \
    libnuma1 \
    libsasl2-2 \
    libsnappy1v5 \
    libsqlite3-0 \
    liblz4-1 \
    liblzma5 \
    libssl1.1 \
    libjemalloc1 \
    libsodium23 && apt-get clean

RUN ldconfig
