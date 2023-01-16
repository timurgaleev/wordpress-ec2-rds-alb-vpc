variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = map(any)
  default = {
    app         = "wordpress",
    environment = "dev"
  }
}

variable "prefix" {
  description = "Prefix for all the resources to be created. Please note thst 2 allows only lowercase alphanumeric characters and hyphen"
  default     = "wordpress"
}

variable "environment" {
  description = "Name of the application environment. e.g. dev, prod, test, staging"
  default     = "dev"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  default     = ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24"]
}

variable "database_subnets_cidrs" {
  description = "List of CIDR blocks for db subnets"
  default     = ["10.0.200.0/24", "10.0.201.0/24", "10.0.202.0/24"]
}

variable "asg_instance_type" {
  description = "AutoScaling Group Instance type"
  default     = "t3.micro"
}
variable "asg_launch_template_description" {
  description = "AutoScaling Group launch template description"
  default     = "Wordpress Launch Template"
}

variable "asg_min_size" {
  description = "AutoScaling Group Min Size "
  default     = 1
}

variable "asg_max_size" {
  description = "AutoScaling Group Max Size "
  default     = 2
}

variable "asg_desired_capacity" {
  description = "AutoScaling Group Desired Capacity"
  default     = 1
}

variable "rds_engine" {
  description = "RDS engine"
  default     = "mariadb"
}

variable "rds_engine_version" {
  description = "RDS engine version"
  default     = "10.6.7"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "site_domain" {
  description = "Domain"
  default     = "example.com"
}

variable "cloudflare_zone" {
  description = "cloudflare Zone Id"
}

variable "dns_ttl" {
  description = "cloudflare for dns = 1 is automatic."
  default     = 1
}

variable "dns_allow_overwrite_records" {
  description = "cloudflare allow overwrite records."
  default     = true
}

variable "cloudflare_api_token" {
  description = "cloudflare api token"
}

variable "ssh_key_name" {
  description = "SSH Key"
}
