####################################################################
# EFS for FS sharing
####################################################################
resource "aws_efs_file_system" "efs" {
  creation_token = "${var.prefix}-${var.environment}-efs"
  tags = var.tags
}

resource "aws_efs_mount_target" "efs_target" {
  count           = length(module.vpc.azs)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = [module.efs_sg.security_group_id]
}
