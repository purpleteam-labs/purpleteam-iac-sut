Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Set any ECS agent configuration options
# Join ECS cluster
# Use heredoc format: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/bootstrap_container_instance.html
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html
cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=${ecs_cluster}
ECS_LOGLEVEL=debug
# Tags added to EC2 instances that are launched using Auto Scaling groups: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html
ECS_CONTAINER_INSTANCE_TAGS={"Name": "sut-autoscaling-userdata", "source": "iac-contOrg-autoscaling"}
#ECS_CONTAINER_INSTANCE_PROPAGATE_TAGS_FROM=ec2_instance
EOF

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/usr/bin/env bash
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_cloudwatch_logs.html#cwlogs_user_data
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-config.html
# Install awslogs and the jq JSON parser
yum install -y awslogs jq

# Inject the CloudWatch Logs configuration file contents
cat > /etc/awslogs/awslogs.conf <<- EOF
[general]
state_file = /var/lib/awslogs/agent-state        

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = /var/log/dmesg
log_stream_name = ${ecs_cluster}/{container_instance_id}

[/var/log/messages]
file = /var/log/messages
log_group_name = /var/log/messages
log_stream_name = ${ecs_cluster}/{container_instance_id}
datetime_format = %b %d %H:%M:%S

[/var/log/ecs/ecs-init.log]
file = /var/log/ecs/ecs-init.log
log_group_name = /var/log/ecs/ecs-init.log
log_stream_name = ${ecs_cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/ecs-agent.log]
file = /var/log/ecs/ecs-agent.log.*
log_group_name = /var/log/ecs/ecs-agent.log
log_stream_name = ${ecs_cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/audit.log]
file = /var/log/ecs/audit.log.*
log_group_name = /var/log/ecs/audit.log
log_stream_name = ${ecs_cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/audit/audit.log]
file = /var/log/audit/audit.log
log_group_name = /var/log/audit/audit.log
log_stream_name = ${ecs_cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/secure]
file = /var/log/secure
log_group_name = /var/log/secure
log_stream_name = ${ecs_cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

EOF

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/usr/bin/env bash
# Write the awslogs bootstrap script to /usr/local/bin/bootstrap-awslogs.sh
cat > /usr/local/bin/bootstrap-awslogs.sh <<- 'EOF'
#!/usr/bin/env bash
exec 2>>/var/log/ecs/cloudwatch-logs-start.log
set -x

until curl -s http://localhost:51678/v1/metadata
do
	sleep 1	
done

# Set the region to send CloudWatch Logs data to (the region where the container instance is located)
cp /etc/awslogs/awscli.conf /etc/awslogs/awscli.conf.bak
region=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
sed -i -e "s/region = .*/region = $region/g" /etc/awslogs/awscli.conf

# Grab the container instance ARN from instance metadata
container_instance_id=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F/ '{print $3}' )

# Replace the container instance ID placeholders with the actual values
cp /etc/awslogs/awslogs.conf /etc/awslogs/awslogs.conf.bak
sed -i -e "s/{container_instance_id}/$container_instance_id/g" /etc/awslogs/awslogs.conf
EOF

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/usr/bin/env bash
# Write the bootstrap-awslogs systemd unit file to /etc/systemd/system/bootstrap-awslogs.service
cat > /etc/systemd/system/bootstrap-awslogs.service <<- EOF
[Unit]
Description=Bootstrap awslogs agent
Requires=ecs.service
After=ecs.service
Before=awslogsd.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/bootstrap-awslogs.sh

[Install]
WantedBy=awslogsd.service
EOF

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/sh
chmod +x /usr/local/bin/bootstrap-awslogs.sh
systemctl daemon-reload
systemctl enable bootstrap-awslogs.service
systemctl enable awslogsd.service
systemctl start awslogsd.service --no-block

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/usr/bin/env bash
# Propagate SSH public keys
cat <<"EOF" > /home/ec2-user/update_ssh_authorized_keys.sh
#!/usr/bin/env bash

set -ex

BUCKET_NAME=sut-public-keys
SSH_USER=ec2-user
MARKER="# KEYS_BELOW_WILL_BE_UPDATED_BY_SCRIPT"
KEYS_FILE=/home/$SSH_USER/.ssh/authorized_keys
TEMP_KEYS_FILE=$(mktemp /tmp/authorized_keys.XXXXXX)
PUB_KEYS_DIR=/home/$SSH_USER/pub_key_files/
PATH=/usr/local/bin:$PATH

BUCKET_URI="s3://$BUCKET_NAME/"

mkdir -p $PUB_KEYS_DIR

# Add marker, if not present, and copy static content.
grep -Fxq "$MARKER" $KEYS_FILE || echo -e "\n$MARKER" >> $KEYS_FILE
line=$(grep -n "$MARKER" $KEYS_FILE | cut -d ":" -f 1)
head -n $line $KEYS_FILE > $TEMP_KEYS_FILE

# Synchronize the keys from the bucket.
aws s3 sync --delete $BUCKET_URI $PUB_KEYS_DIR
for filename in $PUB_KEYS_DIR/*; do
  sed 's/\n\?$/\n/' < $filename >> $TEMP_KEYS_FILE
done

# Move the new authorized keys in place.
chown $SSH_USER:$SSH_USER $KEYS_FILE
chmod 600 $KEYS_FILE
mv $TEMP_KEYS_FILE $KEYS_FILE
if [[ $(command -v "selinuxenabled
") ]]; then
  restorecon -R -v $KEYS_FILE
fi
EOF

#cat <<"EOF" > /home/ec2-user/.ssh/config
#Host *
#  StrictHostKeyChecking yes
#EOF
#chmod 600 /home/ec2-user/.ssh/config
#chown ec2-user:ec2-user /home/ec2-user/.ssh/config

chown ec2-user:ec2-user /home/ec2-user/update_ssh_authorized_keys.sh
chmod 755 /home/ec2-user/update_ssh_authorized_keys.sh

# Execute now
su ec2-user -c /home/ec2-user/update_ssh_authorized_keys.sh

keys_update_frequency="5,20,35,50 * * * *"

# Add to cron
if [ -n "$keys_update_frequency" ]; then
  croncmd="/home/ec2-user/update_ssh_authorized_keys.sh"
  cronjob="$keys_update_frequency $croncmd"
  ( crontab -u ec2-user -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -u ec2-user -
fi

--==BOUNDARY==--
