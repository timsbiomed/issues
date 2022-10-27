#!/bin/sh


docker rm $(docker ps --filter=status=exited --filter=status=created -q)
docker rmi $(docker images -a -q)
docker builder prune

#docker build -t hapi-fhir/hapi-fhir-jpaserver-starter .
docker build -t chrisroederucdenver/hapi-fhir-jpaserver-starter:v6.2-SS .

