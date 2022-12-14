resource "aws_lb_target_group" "target-group" {
  name     = "${var.COMPONENT}-${var.ENV}"
  port     = var.PORT
  protocol = "HTTP"
  vpc_id   = var.VPC_ID

  health_check {
    enabled = true
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 6
    path = "/health"
  }
}

//target group attachememt is not needed here, it will auto done with auto saclling settings.
//resource "aws_lb_target_group_attachment" "attach" {
//  count            = var.INSTANCE_COUNT
//  target_group_arn = aws_lb_target_group.target-group.arn
//  target_id        = aws_spot_instance_request.instance.*.spot_instance_id[count.index]
//  port             = var.PORT
//}

resource "aws_lb_listener" "frontend" {
  count             = var.LB_TYPE == "public" ? 1 : 0
  load_balancer_arn = var.LB_ARN
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:041583668323:certificate/7421a91c-7f8f-41ee-8fc4-b190e3f8aad8"
  //get certificate for our domain name from amazon certificate manager
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

resource "random_integer" "priority" {
  min = 1
  max = 50000
}

resource "aws_lb_listener_rule" "backend" {
  count        = var.LB_TYPE == "private" ? 1 : 0
  listener_arn = var.PRIVATE_LISTENER_ARN
  priority     = random_integer.priority.result

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.roboshop.internal"]
    }
  }
}