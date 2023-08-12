#!/bin/bash
# This script sets up for building the Ontop container.
# In the post, Cloud9 IDE.
# You can also run this from EC2 or your own desktop.

# It assumes you have the git repo cloned. You must run this from the scripts directory

if [ "$#" -ne "1" ]; then
    echo "USAGE build.sh STACKNAME"
    exit 1
fi

STACKNAME=$1
echo STACKNAME
echo $STACKNAME

aws cloudformation describe-stacks --stack-name  $STACKNAME --output text | awk '{print $2 " " $3}' > vars.txt
S3DataBucket=`cat vars.txt | grep S3DataBucket | awk '{print $2}'`

echo S3DataBucket
echo $S3DataBucket

aws s3 sync s3://aws-neptune-customer-samples/neptune-virtualization/blog s3://$S3DataBucket
