#!/usr/bin/env bash
set +e

git clone https://github.com/facebook/proxygen.git

cd proxygen

git checkout "$1"

export os_image=ubuntu:18.04
export gcc_version=7

cd build

./fbcode_builder/make_docker_context.py --os-image=ubuntu:18.04 --gcc-version=7 --make-parallelism=$(($(nproc)+1)) --docker-context-dir=../../

cd ../..
cp Dockerfile Dockerfile_bak
sed -i "s/'BUILD_SHARED_LIBS'='OFF'/'BUILD_SHARED_LIBS'='ON'/g" Dockerfile
#sed -i "s/'BUILD_TESTS'='ON'/'BUILD_TESTS'='OFF'/g" Dockerfile
sed -i "s/RUN env CTEST_OUTPUT_ON_FAILURE=1 make test//" Dockerfile

export PROXYGEN_DOCKER=$(cat Dockerfile)

cat Dockerfile_build.tmpl | envsubst > ../base-build/Dockerfile
cat Dockerfile_run.tmpl | envsubst > ../base-run/Dockerfile