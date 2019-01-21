#!/bin/bash

# Use this script to build the target docker image
# Target is any of [lean, lite, full]
# e.g. `./build.sh lean`

docker build --target $1 -t xplex/$1:latest .
