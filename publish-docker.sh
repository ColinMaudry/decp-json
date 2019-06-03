#!/bin/sh

# publish Dockerfile built image to docker hub
docker build . -t decp-rama
docker tag decp-rama etalab/decp-rama
docker push etalab/decp-rama
