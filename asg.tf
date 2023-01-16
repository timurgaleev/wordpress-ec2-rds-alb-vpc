####################################################################
# AutoSacling Group
####################################################################
module "wp-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.3.0"

  name                      = "${var.prefix}-${var.environment}-asg"
  instance_name             = "${var.prefix}-${var.environment}-web"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"
  vpc_zone_identifier       = module.vpc.public_subnets

  # Launch Template
  launch_template_name        = "${var.prefix}-${var.environment}-lt"
  launch_template_description = var.asg_launch_template_description
  update_default_version      = true
  image_id                    = data.aws_ami.amazon_linux.id
  instance_type               = var.asg_instance_type
  target_group_arns           = module.alb.target_group_arns
  key_name                    = var.ssh_key_name
  user_data = base64encode(templatefile("${path.module}/wordpress-init.sh",
    {
      vars = {
        efs_dns_name = "${resource.aws_efs_file_system.efs.dns_name}"
      }
  }))
  tag_specifications = [
    {
      resource_type = "instance"
      tags          = var.tags
    }
  ]

  network_interfaces = [
    {
      delete_on_termination       = true
      description                 = "eth0"
      device_index                = 0
      security_groups             = [module.ssh_sg.security_group_id]
      associate_public_ip_address = true
    }
  ]

  scaling_policies = {
    scale-up = {
      policy_type        = "SimpleScaling"
      name               = "${var.prefix}-${var.environment}-cpu-scale-up"
      scaling_adjustment = 1
      adjustment_type    = "ChangeInCapacity"
      cooldown           = "500"
    },
    scale-down = {
      policy_type        = "SimpleScaling"
      name               = "${var.prefix}-${var.environment}-cpu-scale-down"
      scaling_adjustment = "-1"
      adjustment_type    = "ChangeInCapacity"
      cooldown           = "500"
    }
  }

  tags = var.tags

  depends_on = [resource.aws_efs_mount_target.efs_target]
}

## Delay to allow time to initialize EC2
resource "time_sleep" "wait_180_seconds" {
  create_duration = "180s"
}
