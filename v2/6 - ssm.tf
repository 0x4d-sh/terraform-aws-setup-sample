resource "random_password" "database_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "secret_location" {
  name = "${var.app_name}/${var.app_environment}/database/password/master"
}

resource "aws_secretsmanager_secret_version" "default" {
  secret_id     = aws_secretsmanager_secret.secret_location.id
  secret_string = random_password.database_password.result
}

resource "aws_iam_role_policy" "secret_policy" {
  name = "password-policy-secretsmanager"
  role = data.aws_iam_role.ecs_task_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "secretsmanager:GetSecretValue"
        ],
        "Effect": "Allow",
        "Resource": [
          "${aws_secretsmanager_secret.secret_location.arn}"
        ]
      }
    ]
  }
  EOF 
}