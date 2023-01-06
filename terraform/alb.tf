#ALB and TG
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"
  name = "adi-ALB-L2P6"
  load_balancer_type = "application"
  vpc_id          = module.vpc.vpc_id
  subnets         = [element(module.vpc.public_subnets, 0), element(module.vpc.public_subnets, 1)]
  security_groups = [aws_security_group.alb-sg.id]

  target_groups = [
    {
      name             = "adi-TG-L2P6"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "404"
      }
    }
  ]
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:acm:us-east-2:421320058418:certificate/ae6924e3-39d6-4c96-88ed-9987e1409918"
    }
  ]
  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
  tags = {
    Name = "adi-ALB-L2P6"
  }
}

#ALB Security Group
resource "aws_security_group" "alb-sg" {
  name   = "adi-ALB-SG-L2P6"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
  ingress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "adi-ALB-SG-L2P6"
  }
}
