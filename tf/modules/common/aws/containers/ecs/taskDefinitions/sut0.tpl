[
  {
    "name": "mongo",
    "image": "mongo:latest",
    "memory": null,
    "memoryReservation": 256,
    "portMappings": [
      {
        "containerPort": 27017,
        "hostPort": 27017,
        "protocol": "tcp"
      }
    ],

    "Healthcheck Comment": "This is the Healthcheck section................................................................",
    "healthCheck": {
      "retries": 3,
      "command": [ "CMD-SHELL", "echo 'db.runCommand(\"ping\").ok' | mongo localhost:27017/${container_name} || exit 1" ],
      "timeout": 3,
      "interval": 20,
      "startPeriod": 8
    },

    "Environment Comment": "This is the Environment section................................................................",
    "cpu": 0,
    "essential": true,
    "entryPoint": null,
    "command": [],
    "workingDirectory": null,
    "secrets": null,
    "environment": [],

    "Startup Dependency Ordering Comment": "This is the Startup Dependency Ordering section................................",
    "dependsOn": null,

    "Container Timeouts Comment": "This is the Container Timeouts section..................................................",
    "startTimeout": null,
    "stopTimeout": null,

    "Network Settings Comment": "This is the Network Settings section......................................................",
    "disableNetworking": null,
    "links": null,
    "hostname": "mongo",
    "dnsServers": null,
    "dnsSearchDomains": null,
    "extraHosts": null,

    "Storage And Logging Comment": "This is the Storage And Logging section................................................",
    "readonlyRootFilesystem": null,
    "mountPoints": [],
    "volumesFrom": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/${sut_key}",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "${sut_key}",
        "awslogs-datetime-format": "%Y-%m-%dT%H:%M:%SZ"
      }
    },
    "firelensConfiguration": null,

    "Security Comment": "This is the Security section......................................................................",
    "privileged": null,
    "user": "mongodb",
    "dockerSecurityOptions": null,

    "Resource Limits Comment": "This is the Resource Limits section........................................................",
    "ulimits": null,

    "Docker Labels Comment": "This is the Docker Labels section............................................................",
    "dockerLabels": {
      "${sut_key}": "mongo"
    },

    "MISC Comment": "MISC..................................................................................................",
    "resourceRequirements": null,
    "systemControls": null,
    "linuxParameters": null,
    "interactive": null,
    "pseudoTerminal": null
  },

  {
    "name": "${container_name}",
    "image": "${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/suts/${container_name}",
    "memory": null,
    "memoryReservation": 256,
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": ${host_port},
        "protocol": "tcp"
      }
    ],

    "Healthcheck Comment": "This is the Healthcheck section................................................................",
    "healthCheck": {
      "retries": 3,
      "command": [ "CMD-SHELL", "wget --spider http://localhost:${container_port}/ || exit 1" ],
      "timeout": 3,
      "interval": 20,
      "startPeriod": 8
    },

    "Environment Comment": "This is the Environment section................................................................",
    "cpu": 0,
    "essential": true,
    "entryPoint": ["sh", "-c"],
    "command": [ "sh -c \"node artifacts/db-reset.js && npm start\"" ],
    "workingDirectory": "/home/node/app",
    "secrets": null,
    "environment": ${sut_environment},

    "Startup Dependency Ordering Comment": "This is the Startup Dependency Ordering section................................",
    "dependsOn": [
      {
        "containerName": "mongo",
        "condition": "START"
      }
    ],

    "Container Timeouts Comment": "This is the Container Timeouts section..................................................",
    "startTimeout": null,
    "stopTimeout": null,

    "Network Settings Comment": "This is the Network Settings section......................................................",
    "disableNetworking": null,
    "links": [ "mongo:mongo" ],
    "hostname": "${container_name}",
    "dnsServers": null,
    "dnsSearchDomains": null,
    "extraHosts": null,

    "Storage And Logging Comment": "This is the Storage And Logging section................................................",
    "readonlyRootFilesystem": null,
    "mountPoints": [],
    "volumesFrom": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/${sut_key}",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "${sut_key}",
        "awslogs-datetime-format": "%Y-%m-%dT%H:%M:%SZ"
      }
    },
    "firelensConfiguration": null,

    "Security Comment": "This is the Security section......................................................................",
    "privileged": null,
    "user": null,
    "dockerSecurityOptions": null,

    "Resource Limits Comment": "This is the Resource Limits section........................................................",
    "ulimits": null,

    "Docker Labels Comment": "This is the Docker Labels section............................................................",
    "dockerLabels": {
      "${sut_key}": "${container_name}"
    },

    "MISC Comment": "MISC..................................................................................................",
    "resourceRequirements": null,
    "systemControls": null,
    "linuxParameters": null,
    "interactive": null,
    "pseudoTerminal": null
  }
]
