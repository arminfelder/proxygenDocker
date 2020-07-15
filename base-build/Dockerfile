### Setup ###

FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]
### Install packages for Debian-based OS ###
ARG COMMIT_TAG

RUN apt-get update && apt-get install -yq autoconf-archive bison build-essential cmake curl flex git gperf joe libboost-all-dev libcap-dev libdouble-conversion-dev libevent-dev libgflags-dev libgoogle-glog-dev libkrb5-dev libpcre3-dev libpthread-stubs0-dev libnuma-dev libsasl2-dev libsnappy-dev libsqlite3-dev libssl-dev libtool netcat-openbsd pkg-config sudo unzip wget python3-venv
RUN apt-get install -yq gcc-'7' g++-'7'
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-'7' 40 --slave /usr/bin/g++ g++ /usr/bin/g++-'7'
RUN update-alternatives --config gcc

USER 'nobody'
USER root
RUN mkdir -p '/home/install' && chown 'nobody' '/home/install'
USER 'nobody'
WORKDIR '/home/install'

### Diagnostics ###

# Builder DockerFBCodeBuilder(gcc_version='7', mvfst/build:cmake_defines={u'BUILD_TESTS': u'OFF'}, facebook/zstd:git_hash=ShellQuoted(u'$(git describe --abbrev=0 --tags origin/master)'), proxygen/proxygen:cmake_defines={u'BUILD_SHARED_LIBS': u'OFF', u'BUILD_TESTS': u'ON', u'BUILD_QUIC': u'ON'}, jedisct1/libsodium:git_hash=u'stable', projects_dir=u'/home', ccache_tgz='', fmtlib/fmt:git_hash=u'6.2.1', wangle/wangle/build:cmake_defines={u'BUILD_TESTS': u'OFF'}, prefix=u'/home/install', os_image='ubuntu:18.04', user=u'nobody', fizz/fizz/build:cmake_defines={u'BUILD_TESTS': u'ON'}, docker_context_dir=u'/tmp/docker-context-zFy6B1', make_parallelism=4, facebook/proxygen:local_repo_dir='/home/armin/CLionProjects/proxygenSrc/build/fbcode_builder/../..')
RUN hostname
RUN cat /etc/issue || echo no /etc/issue
RUN g++ --version || echo g++ not installed
RUN cmake --version || echo cmake not installed

## clone proxygen

USER root
WORKDIR '/home'
RUN git clone https://github.com/facebook/proxygen.git proxygen
USER root
RUN chown -R 'nobody' 'proxygen'
USER 'nobody'
USER root
RUN mkdir -p '/home'/'proxygen'/'proxygen' && chown 'nobody' '/home'/'proxygen'/'proxygen'
USER 'nobody'
WORKDIR '/home'/'proxygen'/'proxygen'
RUN git checkout ${COMMIT_TAG}
RUN export FOLLY_REV=$(sed 's/Subproject commit //' ../build/deps/github_hashes/facebook/folly-rev.txt)
RUN export FIZZ_REV=$(sed 's/Subproject commit //' ../build/deps/github_hashes/facebookincubator/fizz-rev.txt)
RUN export WANGLE_REV=$(sed 's/Subproject commit //' ../build/deps/github_hashes/facebook/wangle-rev.txt)
RUN export MVFST_REV=$(sed 's/Subproject commit //' ../build/deps/github_hashes/facebookincubator/mvfst-rev.txt)


### Check out fmtlib/fmt, workdir build ###

USER root
RUN mkdir -p '/home' && chown 'nobody' '/home'
USER 'nobody'
WORKDIR '/home'
RUN git clone  https://github.com/'fmtlib/fmt'
USER root
RUN mkdir -p '/home'/'fmt'/'build' && chown 'nobody' '/home'/'fmt'/'build'
USER 'nobody'
WORKDIR '/home'/'fmt'/'build'
RUN git checkout '6.2.1'

### Build and install fmtlib/fmt ###

RUN CXXFLAGS="$CXXFLAGS -fPIC -isystem "'/home/install'"/include" CFLAGS="$CFLAGS -fPIC -isystem "'/home/install'"/include" cmake -D'CMAKE_INSTALL_PREFIX'='/home/install' -D'BUILD_SHARED_LIBS'='ON' '..'
RUN make -j '4' VERBOSE=1
RUN make install VERBOSE=1

### Check out facebook/folly, workdir _build ###

USER root
RUN mkdir -p '/home' && chown 'nobody' '/home'
USER 'nobody'
WORKDIR '/home'
RUN git clone  https://github.com/'facebook/folly'
USER root
RUN mkdir -p '/home'/'folly'/'_build' && chown 'nobody' '/home'/'folly'/'_build'
USER 'nobody'
WORKDIR '/home'/'folly'/'_build'
RUN git checkout ${FOLLY_REV}

### Build and install facebook/folly ###

RUN CXXFLAGS="$CXXFLAGS -fPIC -isystem "'/home/install'"/include" CFLAGS="$CFLAGS -fPIC -isystem "'/home/install'"/include" cmake -D'CMAKE_INSTALL_PREFIX'='/home/install' -D'BUILD_SHARED_LIBS'='ON' '..'
RUN make -j '4' VERBOSE=1
RUN make install VERBOSE=1

### Check out jedisct1/libsodium, workdir . ###

USER root
RUN mkdir -p '/home' && chown 'nobody' '/home'
USER 'nobody'
WORKDIR '/home'
RUN git clone  https://github.com/'jedisct1/libsodium'
USER root
RUN mkdir -p '/home'/'libsodium'/'.' && chown 'nobody' '/home'/'libsodium'/'.'
USER 'nobody'
WORKDIR '/home'/'libsodium'/'.'
RUN git checkout 'stable'

### Build and install jedisct1/libsodium ###

RUN ./autogen.sh
RUN LDFLAGS="$LDFLAGS -L"'/home/install'"/lib -Wl,-rpath="'/home/install'"/lib" CFLAGS="$CFLAGS -I"'/home/install'"/include" CPPFLAGS="$CPPFLAGS -I"'/home/install'"/include" PY_PREFIX='/home/install' ./configure --prefix='/home/install'
RUN make -j '4' VERBOSE=1
RUN make install VERBOSE=1

### Check out facebookincubator/fizz, workdir fizz/build ###

USER root
RUN mkdir -p '/home' && chown 'nobody' '/home'
USER 'nobody'
WORKDIR '/home'
RUN git clone  https://github.com/'facebookincubator/fizz'
USER root
RUN mkdir -p '/home'/'fizz'/'fizz/build' && chown 'nobody' '/home'/'fizz'/'fizz/build'
USER 'nobody'
WORKDIR '/home'/'fizz'/'fizz/build'
RUN git checkout ${FIZZ_REV}

### Build and install fizz/fizz/build ###

RUN CXXFLAGS="$CXXFLAGS -fPIC -isystem "'/home/install'"/include" CFLAGS="$CFLAGS -fPIC -isystem "'/home/install'"/include" cmake -D'CMAKE_INSTALL_PREFIX'='/home/install' -D'BUILD_SHARED_LIBS'='ON' -D'BUILD_TESTS'='ON' '..'
RUN make -j '4' VERBOSE=1
RUN make install VERBOSE=1

### Check out facebook/wangle, workdir wangle/build ###

USER root
RUN mkdir -p '/home' && chown 'nobody' '/home'
USER 'nobody'
WORKDIR '/home'
RUN git clone  https://github.com/'facebook/wangle'
USER root
RUN mkdir -p '/home'/'wangle'/'wangle/build' && chown 'nobody' '/home'/'wangle'/'wangle/build'
USER 'nobody'
WORKDIR '/home'/'wangle'/'wangle/build'
RUN git checkout ${WANGLE_REV}

### Build and install wangle/wangle/build ###

RUN CXXFLAGS="$CXXFLAGS -fPIC -isystem "'/home/install'"/include" CFLAGS="$CFLAGS -fPIC -isystem "'/home/install'"/include" cmake -D'CMAKE_INSTALL_PREFIX'='/home/install' -D'BUILD_SHARED_LIBS'='ON' -D'BUILD_TESTS'='OFF' '..'
RUN make -j '4' VERBOSE=1
RUN make install VERBOSE=1

### Check out facebook/zstd, workdir . ###

USER root
RUN mkdir -p '/home' && chown 'nobody' '/home'
USER 'nobody'
WORKDIR '/home'
RUN git clone  https://github.com/'facebook/zstd'
USER root
RUN mkdir -p '/home'/'zstd'/'.' && chown 'nobody' '/home'/'zstd'/'.'
USER 'nobody'
WORKDIR '/home'/'zstd'/'.'
RUN git checkout $(git describe --abbrev=0 --tags origin/master)

### Build and install zstd ###

RUN make -j '4' VERBOSE=1 'PREFIX'='/home/install'
RUN make install VERBOSE=1 'PREFIX'='/home/install'

### Check out facebookincubator/mvfst, workdir build ###

USER root
RUN mkdir -p '/home' && chown 'nobody' '/home'
USER 'nobody'
WORKDIR '/home'
RUN git clone  https://github.com/'facebookincubator/mvfst'
USER root
RUN mkdir -p '/home'/'mvfst'/'build' && chown 'nobody' '/home'/'mvfst'/'build'
USER 'nobody'
WORKDIR '/home'/'mvfst'/'build'
RUN git checkout ${MVFST_REV}

### Build and install mvfst/build ###

RUN CXXFLAGS="$CXXFLAGS -fPIC -isystem "'/home/install'"/include" CFLAGS="$CFLAGS -fPIC -isystem "'/home/install'"/include" cmake -D'CMAKE_INSTALL_PREFIX'='/home/install' -D'BUILD_SHARED_LIBS'='ON' -D'BUILD_TESTS'='OFF' '..'
RUN make -j '4' VERBOSE=1
RUN make install VERBOSE=1

### Check out facebook/proxygen, workdir proxygen ###

USER root
RUN mkdir -p '/home' && chown 'nobody' '/home'
USER 'nobody'
WORKDIR '/home'

WORKDIR '/home'/'proxygen'/'proxygen'

### Build and install proxygen/proxygen ###

RUN CXXFLAGS="$CXXFLAGS -fPIC -isystem "'/home/install'"/include" CFLAGS="$CFLAGS -fPIC -isystem "'/home/install'"/include" cmake -D'CMAKE_INSTALL_PREFIX'='/home/install' -D'BUILD_SHARED_LIBS'='ON' -D'BUILD_TESTS'='ON' -D'BUILD_QUIC'='ON' '..'
RUN make -j '4' VERBOSE=1
RUN make install VERBOSE=1

### Run proxygen tests ###

# RUN env CTEST_OUTPUT_ON_FAILURE=1 make test

FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]

RUN mkdir /usr/local/lib/proxygen

COPY --from=0 /home/install/lib/ /usr/local/lib/proxygen/
COPY --from=0 /home/install/include/ /usr/local/include/

RUN apt-get update && apt-get install -y libboost-all-dev \
     libcap-dev \
     libdouble-conversion-dev \
     libevent-dev libgflags-dev \
     libgoogle-glog-dev \
     libkrb5-dev \
     libpcre3-dev \
     libpthread-stubs0-dev \
     libnuma-dev \
     libsasl2-dev \
     libsnappy-dev \
     libsqlite3-dev \
     libssl-dev \
     openssh-server \
     cmake \
     build-essential \
     cppcheck \
     rsync \
     gdb \
     valgrind \
     clang-tools \
    && apt-get clean

RUN echo "/usr/local/lib/proxygen/" > /etc/ld.so.conf.d/proxygen.conf

RUN ldconfig

RUN mkdir /var/run/sshd

RUN echo 'root:GaxahhohphuYea9cah4Od2equ0cui3eich4' | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]