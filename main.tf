########################################
# root/main.tf
########################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63"
    }
  }
}

# УВАГА: провайдера в root можна не оголошувати,
# бо він уже визначений всередині модулів vpc/ і eks/.
# Якщо хочеш оголосити тут — тоді прибери provider з модулів.
# provider "aws" { region = var.region }

# 1) Спершу створюємо VPC
module "vpc" {
  source = "./vpc"

  name            = var.vpc_name
  cidr            = var.vpc_cidr
  az_count        = var.vpc_az_count
  enable_nat_gw   = var.enable_nat_gw
  single_nat_gw   = var.single_nat_gw
  region          = var.region
  tags            = var.tags
}

# 2) Потім створюємо EKS, прямо під’єднуючи outputs із VPC
#    (remote_state тут НЕ потрібен, бо ми і так у root)
module "eks" {
  source = "./eks"

  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  region           = var.region

  # вимикаємо remote_state і подаємо значення з module.vpc
 
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  cpu_instance_type = var.cpu_instance_type
  cpu_min_size      = var.cpu_min_size
  cpu_desired_size  = var.cpu_desired_size
  cpu_max_size      = var.cpu_max_size

  tags = var.tags
}
