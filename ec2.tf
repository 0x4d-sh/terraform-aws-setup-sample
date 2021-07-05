# ec2.tf

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

data "template_file" "user_data" {
  template = file("./templates/ec2/apachebench.sh")

  vars = {
    app_name        = var.app_name
    app_environment = var.app_environment
    app_image       = var.app_image
    app_port        = var.app_port
    aws_region      = var.aws_region
  }
}

resource "aws_instance" "instance" {
    ami             = data.aws_ami.ubuntu.id
    instance_type   = "t2.micro"
    subnet_id       = aws_subnet.private.0.id
    user_data       = "${data.template_file.user_data.rendered}"
    security_groups = [aws_security_group.alb.id]
    iam_instance_profile    = var.ec2_iam_role

    root_block_device {
        delete_on_termination = true
        encrypted             = false
        # volume_size           = var.root_device_size
        # volume_type           = var.root_device_type
    }

    tags = {
            Name = "${var.app_name}-${var.app_environment}-ec2"
            env = var.app_environment
            project = var.app_name
            ssm = var.app_ssm
            owner = var.app_owner
    }
}