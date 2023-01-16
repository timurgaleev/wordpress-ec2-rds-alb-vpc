data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "this" {}

#####################################################################
# Get AWS AMI ID
#####################################################################

data "aws_ami" "amazon_linux" {
  #executable_users = ["self"]
  most_recent = true
  name_regex  = "^amzn2*"
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_instances" "wp-web" {
  instance_tags = var.tags

  filter {
    name   = "key-name"
    values = ["${var.prefix}-${var.environment}-key"]
  }
  instance_state_names = ["running"]
  depends_on           = [module.wp-asg, resource.time_sleep.wait_180_seconds]
}
