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

  //user_data = filebase64("${path.module}/example.sh")
}
