#!/bin/bash

# This script sets up for building and deploying the Ontop container.
# In the post, we run this from a Sagemaker notebook with extra IAM policies with access to CFN, ECR, and ECS.
# You can also run this from EC2, Cloud9, or your own desktop.

# It assumes you have the git repo cloned. You must run this from the scripts directory

# Will need the stackname you used. In the notebook instance, we have it. Otherwise, override the value with the name you used.
STACKNAME=`source ~/.bashrc ; echo $STACKNAME`

# Check we are running from the correct directory
FILE=deploy.sh
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

echo Here are the vars
cat vars.txt