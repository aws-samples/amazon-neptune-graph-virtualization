#!/bin/bash
# This script sets up for building the Ontop container.
# In the post, Cloud9 IDE.
# You can also run this from EC2 or your own desktop.

# It assumes you have the git repo cloned. You must run this from the scripts directory

if [ "$#" -ne "2" ]; then
    echo "USAGE deploy.sh STACKNAME ECSSTACKNAME"
    exit 1
fi

STACKNAME=$1
ECSSTACKNAME=$2
echo STACKNAME $STACKNAME
echo ECSSTACKNAME $ECSSTACKNAME

# Check we are running from the correct directory
FILE=Dockerfile
if [ -f "$FILE" ]; then
    echo "You are running from the correct directory"
else 
    echo "You should run from scripts directory of git clone"
    exit 1
fi

# extract values needed for build
aws cloudformation describe-stacks --stack-name  $STACKNAME --output text | awk '{print $2 " " $3}' > vars.txt
VPC=`cat vars.txt | grep VPC | awk '{print $2}'`
PrivateSubnet1=`cat vars.txt | grep PrivateSubnet1 | awk '{print $2}'`
ECSCluster=`cat vars.txt | grep ECSCluster | awk '{print $2}'`
LakeSecurityGroup=`cat vars.txt | grep ECSSecurityGroup | awk '{print $2}'`
LakeTaskRole=`cat vars.txt | grep ECSTaskRole | awk '{print $2}'`

echo VPC $VPC
echo PrivateSubnet1 $PrivateSubnet1
echo ECSCluster $ECSCluster
echo LakeSecurityGroup $LakeSecurityGroup
echo LakeTaskRole $LakeTaskRole

BUILDDIR=`echo $(cd ../ && pwd)`

# Run CFN to create ECS task
# Change path if necessary
aws cloudformation create-stack --stack-name ${ECSSTACKNAME} \
  --template-body file://$BUILDDIR/cfn/ecs_task.yaml \
  --parameters \
  ParameterKey=VPC,ParameterValue=${VPC} \
  ParameterKey=Subnet,ParameterValue=${PrivateSubnet1} \
  ParameterKey=ECSCluster,ParameterValue=${ECSCluster} \
  ParameterKey=TaskDefName,ParameterValue=ontop-graph-weather-lake \
  ParameterKey=SecurityGroup,ParameterValue=${LakeSecurityGroup} \
  ParameterKey=TaskRole,ParameterValue=${LakeTaskRole} \
   --capabilities CAPABILITY_NAMED_IAM
