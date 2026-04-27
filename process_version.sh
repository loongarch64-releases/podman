#!/bin/bash
set -euo pipefail

readonly version="$1"

readonly org='containers'
readonly proj='podman'
readonly arch='loongarch64'
readonly goarch='loong64'
readonly proj_name="${proj}-${version}"

# 映射目录
readonly workspace="/workspace"
readonly dists="${workspace}/dists"
readonly patches="${workspace}/patches"

readonly build="/build"
readonly source_root="${build}/${proj_name}"
readonly build_root="${build}/${proj_name}"
readonly package_root="${dists}/${proj_name}"

mkdir -p "${build}"


apply_patches()
{
    for patch_ in ${patches}/*.patch;
    do
        git apply ${patch_}
    done
}

fetch_source_code()
{
    rm -rf "${source_root}"
    git clone --branch "v${version}" --depth=1 "https://github.com/${org}/${proj}" "${source_root}"
}

build(){
    pushd "${build_root}"
        apply_patches
        make bin/podman-remote-static-linux_loong64
    popd
}

package(){
    rm -rf "${package_root}"
    mkdir -p "${package_root}"
    pushd "${package_root}"
        cp -r ${build_root}/bin ./
        tar czvf podman-remote-static-linux_loong64.tar.gz bin
    popd

}

main()
{
    fetch_source_code
    build
    package
}

main "$@"
