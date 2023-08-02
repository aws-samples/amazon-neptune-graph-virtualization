#!/bin/bash

if [ "$#" -ne "1" ]; then
    echo "USAGE build.sh STACKAME"
    exit 1
fi

STACKNAME=$1

# extract values needed for build
aws cloudformation describe-stacks --stack-name  $STACKNAME --output text | awk '{print $2 " " $3}' > vars.txt
REGION=`aws configure get region`
ACCOUNT=`aws sts get-caller-identity --query "Account" --output text`
export REGION
export ACCOUNT
echo "REGION " $REGION >> vars.txt
echo "ACCOUNT " $ACCOUNT >> vars.txt
export S3WorkingBucket=`cat vars.txt | grep S3WorkingBucket | awk '{print $2}'`
export ECSCluster=`cat vars.txt | grep ECSCluster | awk '{print $2}'`
export PrivateSubnet1=`cat vars.txt | grep PrivateSubnet1 | awk '{print $2}'`
export SourceS3BucketName=`cat vars.txt | grep SourceS3BucketName | awk '{print $2}'`
export SourceS3BucketFolderNoSlash=`cat vars.txt | grep SourceS3BucketFolderNoSlash | awk '{print $2}'`
export VPC=`cat vars.txt | grep VPC | awk '{print $2}'`
export LakeSecurityGroup=`cat vars.txt | grep LakeSecurityGroup | awk '{print $2}'`
export LakeTaskRole=`cat vars.txt | grep LakeTaskRole | awk '{print $2}'`
export RDSEndpoint=`cat vars.txt | grep RDSEndpoint | awk '{print $2}'`

mkdir -p lake/jdbc
wget https://s3.amazonaws.com/athena-downloads/drivers/JDBC/SimbaAthenaJDBC-2.0.33.1002/AthenaJDBC42-2.0.33.jar
mv AthenaJDBC42-2.0.33.jar lake/jdbc/AthenaJDBC42-2.0.33.jar
