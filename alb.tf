####################################################################
# ELB
####################################################################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.10.0"

  name               = "${var.prefix}-${var.environment}-elb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.http_sg.security_group_id]
  internal           = false

  http_tcp_listeners = [
    {
      port               = "80"
      protocol           = "HTTP"
      action_type        = "redirect"
      target_group_index = 0
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.acm_certificate_arn
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name_prefix      = "h1"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 120
        path                = "/"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 20
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]

  tags = var.tags
}
