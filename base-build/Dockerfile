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

RUN apt-get update && apt-get --no-install-recommends install -y libboost-all-dev \
     cmake \
     libcap-dev \
     libdouble-conversion-dev \
     libevent-dev libgflags-dev \
     libgoogle-glog-dev \
     libkrb5-dev \
     libpcre3-dev \
     libpthread-stubs0-dev \
     libnuma-dev \
     libsasl2-dev \
     libjemalloc-dev \
     libsnappy-dev \
     libsqlite3-dev \
     libiberty-dev \
     liblz4-dev \
     liblzma-dev \
     zlib1g-dev \
     libssl-dev \
     libsnappy-dev \
     libsodium-dev \
     libzstd-dev \
     openssh-server \
     build-essential \
     cppcheck \
     rsync \
     gdb \
     valgrind \
     clang-tools \
    && apt-get clean

COPY --from=0 /opt/proxygen/proxygen/_build /opt/proxygen/proxygen/_build/

RUN ldconfig

RUN mkdir /var/run/sshd

RUN echo 'root:GaxahhohphuYea9cah4Od2equ0cui3eich4' | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]