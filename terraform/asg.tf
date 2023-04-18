module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "adi-ASG-L2P6"

  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  target_group_arns         = module.alb.target_group_arns
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = [element(module.vpc.private_subnets, 0), element(module.vpc.private_subnets, 1)]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 60
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
    
    
  # Launch template
  launch_template_name        = "adi-LT-L2P6"
  launch_template_description = "Launch template example"
  update_default_version      = true
  security_groups             = [aws_security_group.asg-sg.id]
  image_id                    = "ami-0ec52ef324bd47f0b"
  instance_type               = "t3a.small"
  key_name                    = "adikp1"
  ebs_optimized               = true
  enable_monitoring           = true

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "adi-ec2-role"
  iam_role_path               = "/ec2/"
  iam_role_description        = "Complete IAM role example"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonRDSFullAccess         = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
    AmazonEC2RoleforSSM         = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
    CloudWatchAgentAdminPolicy  = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
    AmazonS3FullAccess          = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    CloudWatchAgentServerPolicy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    AWSCodeDeployRole           = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
    AmazonSSMFullAccess         = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  }
}
    
# Scaling Policy
resource "aws_autoscaling_policy" "asg-policy" {
  count                     = 1
  name                      = "asg-cpu-policy"
  autoscaling_group_name    = module.asg.autoscaling_group_name
  estimated_instance_warmup = 60
  policy_type               = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

#ASG Security Group
resource "aws_security_group" "asg-sg" {
  name   = "adi-ASG-SG-L2P6"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    security_groups = [aws_security_group.pritunl-sg.id]
  }
    
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "TCP"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "adi-ASG-SG-L2P6"
  }
}
