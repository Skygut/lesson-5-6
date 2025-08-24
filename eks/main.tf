########################################
# eks/main.tf (root-mode, minimal)
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

provider "aws" {
  region = var.region
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  # Cluster
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  enable_irsa                     = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false
  # Дати творцю кластера (тобто твоєму поточному AWS IAM principal) права cluster-admin
  enable_cluster_creator_admin_permissions = true

  # Networking (передається з root)
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Node groups: основний ON_DEMAND + дешевший SPOT
  eks_managed_node_groups = {
    main = {
      name           = "main-ng"
      instance_types = [var.cpu_instance_type]  # напр., t3.medium
      capacity_type  = "ON_DEMAND"

      min_size     = var.cpu_min_size
      desired_size = var.cpu_desired_size
      max_size     = var.cpu_max_size
    }

    cheap = {
      name           = "cheap-ng"
      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"

      min_size     = 0
      desired_size = 0
      max_size     = 3
    }
  }

  tags = var.tags
}
