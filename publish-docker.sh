#!/bin/sh

# fail on error
set -e

# publish Dockerfile built image to docker hub
docker build . -t decp-rama
docker tag decp-rama 139bercy/decp-rama
docker push 139bercy/decp-rama
