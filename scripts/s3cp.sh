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

#
# We're copying from public bucket in us-east-1.
# VPC endpoint does not allow cp or sync cross-region
# So we copy to holding area
#

rm -rf holding
mkdir -p holding
aws s3 cp --recursive s3://aws-neptune-customer-samples/neptune-virtualization/blog/rdf holding
aws s3 cp --recursive holding s3://$S3DataBucket/rdf
rm -rf holding

#YEARS=( 1979 1980 1981 1982 1983 1984 1985 )
YEARS=( 1983 1984 1985 )
for y in "${YEARS[@]}"
do
    mkdir -p holding
    aws s3 cp s3://aws-neptune-customer-samples/neptune-virtualization/blog/lake/$y.zip holding/$y.zip
    cd holding
    unzip $y.zip >/dev/null 2>/dev/null
    rm $y.zip
    cd ..
    aws s3 cp --recursive holding/$y s3://$S3DataBucket/lake/climate/$y >/dev/null 2>/dev/null
    rm -rf holding
done

