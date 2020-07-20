#!/bin/bash

# https://github.com/awslabs/amazon-ecr-credential-helper/releases/ needs to be installed. Install it in the same place as terraform and symlinked.
# If there are still issues with authenticating, work through this: https://github.com/awslabs/amazon-ecr-credential-helper/issues/63#issuecomment-328318116

# Export The following variables from the .env file to the current shell:
# AWS_REGION
# AWS_PROFILE
# AWS_ACCOUNT_ID
export $(egrep -v '^#' .env | xargs)

echo
echo "Using AWS Region \"$AWS_REGION\", AWS Account Id \"$AWS_ACCOUNT_ID\", AWS Profile \"$AWS_PROFILE\""
echo
echo "Building the images..............................................................................."
echo

npm run dc-build-nodegoat

echo
echo "Tagging the images................................................................................"
echo

docker tag nodegoat_web:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/suts/nodegoat:latest

echo "The following images are currently in the suts/nodegoat repository..............................."
echo
echo $(aws ecr list-images --region $AWS_REGION --repository-name suts/nodegoat --filter tagStatus=ANY --output json --query 'imageIds[*]') | jq
echo

echo "Pushing the new images............................................................................"
echo
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/suts/nodegoat:latest
echo
echo "After pushing, the following images are currently in the suts/nodegoat repository................"
echo
echo $(aws ecr list-images --region $AWS_REGION --repository-name suts/nodegoat --filter tagStatus=ANY --output json --query 'imageIds[*]') | jq
echo
echo "Waiting 8 seconds for untagging..."
sleep 8
echo "Deleting the following old (untagged) images in the suts/nodegoat repository....................."
echo
untagedNodeGoatImages=$(aws ecr list-images --region $AWS_REGION --repository-name suts/nodegoat --filter tagStatus=UNTAGGED --output json --query 'imageIds[*]')
echo $untagedNodeGoatImages | jq
echo
aws ecr batch-delete-image --repository-name suts/nodegoat --image-ids "$untagedNodeGoatImages"

echo
echo "The following images are left in the suts/nodegoat repository...................................."
echo
nodeGoatImages=$(aws ecr list-images --region $AWS_REGION --repository-name suts/nodegoat --filter tagStatus=ANY --output json --query 'imageIds[*]')
echo $nodeGoatImages | jq

