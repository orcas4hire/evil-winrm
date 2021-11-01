#!/usr/bin/env bash
if [ $# -eq 0 ]
  then
    tag='latest'
  else
    tag=$1
fi

# Build image
docker build -t evil-winrm:$tag .

# Cleanup / remove intermediate images
docker rmi $(docker images -f "dangling=true" -q)
