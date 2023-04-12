#!/bin/bash

set -e

__dir=$(dirname $(realpath $0))

container=decidim
image=git.codeandomexico.org/codeandomexico/decidim/decidim

if [[ -z $@ ]]; then
    cmd=$image
    name="--name=$container"

    podman rm -i $container
else
    cmd="-it $image $@"
fi

podman run --rm \
    --network slirp4netns:allow_host_loopback=true \
    --env-file $__dir/../../../.env \
    --publish 3000:3000 \
    $name \
    $cmd
