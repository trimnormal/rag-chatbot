resource "aws_lb" "this" {
  name               = "zc-portfolio-app"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB.id]
  subnets            = data.aws_subnets.this.ids
  access_logs {
    bucket  = aws_s3_bucket.LogBucket.id
    prefix  = "lb-access-logs"
    enabled = true
  }
}

data "aws_vpcs" "this" {
  tags = {
    name = "default"
  }
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
  filter {
    name   = "availability-zone"
    values = ["us-east-1e", "us-east-1f"]
  }
}

resource "aws_lb_target_group" "this" {
  name                 = "zc-portfolio-app"
  port                 = 8501
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = data.aws_vpcs.this.ids[0]
  deregistration_delay = 5 #5?
}

resource "aws_lb_listener" "HTTP" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "HTTPS" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.this.arn
  #aws_acm_certificate.this.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

data "aws_acm_certificate" "this" {
  domain      = "zacharycorbishley.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}