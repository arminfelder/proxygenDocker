# Base Images for building/running applications based on Facebooks proxygen library

    docker build --build-arg COMMIT_TAG=v2020.07.13.00  -t  afelder/proxygen:v2020.07.13.00 ./base-run
    
    docker build --build-arg COMMIT_TAG=v2020.07.13.00  -t  afelder/proxygen:v2020.07.13.00-builder ./base-build

