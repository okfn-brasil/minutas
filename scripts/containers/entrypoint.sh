#!/bin/bash

set -e

if [[ -z $@ ]]; then
    echo "Running migrations..."
    bin/rails db:migrate
    echo "Starting app..."
    exec bin/rails server
else
    exec $@
fi
