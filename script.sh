#!/bin/sh
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 680032936053.dkr.ecr.us-east-1.amazonaws.com
docker tag alpine:latest 680032936053.dkr.ecr.us-east-1.amazonaws.com/alpine:$1
docker push 680032936053.dkr.ecr.us-east-1.amazonaws.com/alpine:latest
