#!/bin/bash

__dir=$(dirname $(realpath $0))

image=git.codeandomexico.org/codeandomexico/decidim/decidim:latest

podman build -t $image --file $__dir/../../Dockerfile $__dir/../../
