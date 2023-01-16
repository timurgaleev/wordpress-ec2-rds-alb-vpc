######################################################################
# Output
######################################################################

output "alb_dns_name" {
  value       = module.alb.lb_dns_name
  sensitive   = false
  description = "ALB DNS Name to connect frontend"
}

output "ec2_ssh_IP" {
  value       = data.aws_instances.wp-web.public_ips
  sensitive   = false
  description = "EC2 Pulic IP for SSH"
}

output "DB_Username" {
  value       = module.db.db_instance_username
  sensitive   = true
  description = "Database Username"
}

output "DB_Name" {
  value       = module.db.db_instance_name
  sensitive   = false
  description = "Database Name"
}

output "DB_Password" {
  value       = module.db.db_instance_password
  sensitive   = true
  description = "Database password"
}

output "DB_Connection_Name" {
  value       = module.db.db_instance_endpoint
  sensitive   = false
  description = "Database connection string"
}
