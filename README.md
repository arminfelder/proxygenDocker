# Base Images for building/running applications based on Facebooks proxygen library

    docker build --build-arg COMMIT_TAG=v2024.12.23.00  -t  afelder/proxygen:v2024.12.23.00 ./base-run
    
    docker build --build-arg COMMIT_TAG=v2024.12.23.00  -t  afelder/proxygen:v2024.12.23.00-builder ./base-build

