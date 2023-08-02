#!/bin/bash

if [ "$#" -ne "1" ]; then
    echo "USAGE build.sh STACKAME"
    exit 1
fi

STACKNAME=$1

aws cloudformation create-stack --stack-name ${STACKNAME} \
  --template-body file:///home/ec2-user/environment/ontop/cfn/ecs_task.yaml \
  --parameters \
  ParameterKey=VPC,ParameterValue=${VPC} \
  ParameterKey=Subnet,ParameterValue=${PrivateSubnet1} \
  ParameterKey=ECSCluster,ParameterValue=${ECSCluster} \
  ParameterKey=TaskDefName,ParameterValue=ontop-lake \
  ParameterKey=SecurityGroup,ParameterValue=${LakeSecurityGroup} \
  ParameterKey=TaskRole,ParameterValue=${LakeTaskRole} \
   --capabilities CAPABILITY_NAMED_IAM
