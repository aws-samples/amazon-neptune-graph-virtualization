#!/bin/bash
# This script sets up for building the Ontop container.
# In the post, we run this from a Sagemaker notebook with extra IAM policies with access to CFN, ECR, and ECS.
# You can also run this from EC2, Cloud9, or your own desktop.

# It assumes you have the git repo cloned. You must run this from the scripts directory

# Will need the stackname you used. In the notebook instance, we have it. Otherwise, override the value with the name you used.
STACKNAME=`source ~/.bashrc ; echo $STACKNAME`

# Check we are running from the correct directory
FILE=Dockerfile
if [ -f "$FILE" ]; then
    echo "You are running from the correct directory"
else 
    echo "You should run from scripts directory of git clone"
    exit 1
fi

# Download the Athena driver
THISDIR=`pwd`
mkdir jdbc
cd jdbc
wget https://downloads.athena.us-east-1.amazonaws.com/drivers/JDBC/SimbaAthenaJDBC-2.1.0.1000/AthenaJDBC42-2.1.0.1000.jar
cd $THISDIR

# extract values needed for build
REGION=`aws configure get region`
ACCOUNT=`aws sts get-caller-identity --query "Account" --output text`
aws cloudformation describe-stacks --stack-name  $STACKNAME --output text | awk '{print $2 " " $3}' > vars.txt
S3DataBucket=`cat vars.txt | grep S3DataBucket | awk '{print $2}'`
echo Region $REGION
echo Account $ACCOUNT
echo S3 $S3DataBucket

# Modify ontop properties file to use region and bucket
cp ontop/climate.properties ontop/climate.properties.orig
cat ontop/climate.properties.orig | sed s/__REGION__/$REGION/g | sed s/__DATABUCKET__/$S3DataBucket/g > ontop/climate.properties

# Build the image and push to ECR
echo "build docker image and push to ECR"
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com
docker build -t ontop-lake .
docker tag ontop-lake:latest ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/ontop-lake:latest 
docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/ontop-lake:latest
