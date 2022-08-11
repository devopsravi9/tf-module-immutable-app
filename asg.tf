resource "aws_autoscaling_group" "main" {
  desired_capacity   = var.ASG_DESIRED
  max_size           = var.ASG_MAX
  min_size           = var.ASG_MIN
  vpc_zone_identifier = [var.PRIVATE_SUBNET_ID]
  target_group_arns  = [aws_lb_target_group.target-group.arn]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}
