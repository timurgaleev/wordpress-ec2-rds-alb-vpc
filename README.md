# Run WordPress on AWS EC2 with Cloudflare domain through Terraform

This repository contains AWS infrastructure for WordPress

## How to use this example

- Run `terraform init`
- Run `terraform plan` and review
- Run `terraform apply`

## Structure
This repository provides the minimal set of resources, which may be required for starting comfortably developing the process of new IaC project:

  acm.tf - AWS Certificate Manager Terraform module

  alb.tf - AWS Application and Network Load Balancer Terraform module

  asg.tf - AWS Auto Scaling Group (ASG) Terraform module

  cloudflare.tf - Cloudflare Provider

  efs.tf - Provides an Elastic File System (EFS) File System resource

  output.tf - Terraform Output Values

  rds.tf - AWS RDS Terraform module

  security_group.tf - AWS EC2-VPC Security Group Terraform module

  vpc.tf - AWS VPC Terraform module

  variables.tf - variables used in Terraform. Customize it for your project data !!!

### Cleaning up

You can destroy this WordPress by running:

```bash
terraform plan -destroy
terraform destroy  --force
```
