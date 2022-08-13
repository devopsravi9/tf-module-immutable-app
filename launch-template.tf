resource "aws_launch_template" "launch_template" {
  name = local.TAG_PREFIX
  image_id = data.aws_ami.main.image_id
  instance_type = var.INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.main.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.allow-secretmanager-readaccess.name
  }

  instance_market_options {
    market_type = "spot"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.TAG_PREFIX
    }
  }

  tag_specifications {
    resource_type = "spot-instances-request"

    tags = {
      Name = local.TAG_PREFIX
    }
  }

  //user_data = filebase64("${path.module}/example.sh")

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    ENV                    = var.ENV
    COMPONENT              = var.COMPONENT
    DOCDB_ENDPOINT         = var.DOCDB_ENDPOINT
    DOCDB_USER             = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["DOCDB_USER"]
    DOCDB_PASS             = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["DOCDB_PASS"]
    RABBITMQ_USER_PASSWORD = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["RABITMQ_USER_PASSWORD"]
    MYSQL_ENDPOINT         = var.MYSQL_ENDPOINT
    REDDIS_ENDPOINT        = var.REDDIS_ENDPOINT
  }))
}
