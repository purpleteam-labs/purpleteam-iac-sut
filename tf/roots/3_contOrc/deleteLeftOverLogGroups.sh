#!/bin/bash

if [[ "$1" != "" ]]; then
  env_file="$1"
  echo "Loading env file: $env_file"
  export $(egrep -v '^#' $env_file | xargs)
else
    echo "You must supply the location of the .env file as an argument."
    exit
fi

echo "Using the aws profile ($AWS_PROFILE) and region ($AWS_REGION) to run the commands."
echo
echo "Attempting to delete log group /var/log/audit/audit.log"
aws logs delete-log-group --log-group-name /var/log/audit/audit.log --profile $AWS_PROFILE --region $AWS_REGION
echo
echo "Attempting to delete log group /var/log/ecs/ecs-agent.log"
aws logs delete-log-group --log-group-name /var/log/ecs/ecs-agent.log --profile $AWS_PROFILE --region $AWS_REGION
echo
echo "Attempting to delete log group /var/log/ecs/audit.log"
aws logs delete-log-group --log-group-name /var/log/ecs/audit.log --profile $AWS_PROFILE --region $AWS_REGION
echo
echo "Attempting to delete log group /var/log/messages"
aws logs delete-log-group --log-group-name /var/log/messages --profile $AWS_PROFILE --region $AWS_REGION

