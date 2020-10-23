#!/usr/bin/env bash

VERSION=$1

./gen_dockerfiles "${VERSION}"

git commit -A -m "${VERSION}"
git tag "${VERSION}"
git push origin "${VERSION}"

docker build -t afelder/proxygen:"${VERSION}" ../base-run/
docker build -t afelder/proxygen:"${VERSION}"-builder ../base-build/

docker push afelder/proxygen:"${VERSION}"
docker push afelder/proxygen:"${VERSION}-builder"