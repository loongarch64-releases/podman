#!/bin/bash

set -ex;

org='podman-container-tools'
proj='podman'

docker_build() {
    local version=$(curl -sL https://api.github.com/repos/${org}/${proj}/releases/latest | jq -r ".tag_name")
    local builder="${org}-${proj}-builder"
    local version=${version#v}
    docker build -t ${builder} .
    docker run --rm -v$(pwd):/workspace -e PODMAN_VERSION=${version} ${builder}
    docker rmi ${builder}
}

docker_build
