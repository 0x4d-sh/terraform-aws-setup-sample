[
  {
    "name": "${app_name}",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/fargate/${app_name}-${app_environment}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "environment": [
      {
          "name": "PUID",
          "value": "0"
      },{
          "name": "PGID",
          "value": "0"
      },{
          "name": "TZ",
          "value": "Asia/Singapore"
      },{
          "name": "DOMAINMOD_WEB_ROOT",
          "value": ""
      },{
          "name": "DOMAINMOD_DATABASE_HOST",
          "value": "${db_url}"
      },{
          "name": "DOMAINMOD_DATABASE",
          "value": "${db_name}"
      },{
          "name": "DOMAINMOD_USER",
          "value": "${db_user}"
      },{
          "name": "DOMAINMOD_PASSWORD",
          "value": "${db_password}"
      },{
          "name": "SIMPLESAMLPHP_VERSION",
          "value": "1.19.1"
      },{
          "name": "SIMPLESAML_BASEURL",
          "value": "${sso_ssp}"
      },{
          "name": "OKTA_SSO_METADATA",
          "value": "${sso_metadata}"
      }
    ]
  }
]