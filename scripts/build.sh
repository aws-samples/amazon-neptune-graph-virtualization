#!/bin/bash

cp ontop/lake.properties ontop/lake.properties.orig
cat ontop/lake.properties.orig | sed s/__REGION__/$REGION/g | sed s/__S3BUCKET__/$S3WorkingBucket/g > ontop/lake.properties

echo "build docker image and push to ECR"
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com
docker build -t ontop-lake .
docker tag ontop-lake:latest ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/ontop-lake:latest 
docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/ontop-lake:latest
