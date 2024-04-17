provider "kubernetes" {
    load_config_file = "false"
    host = data.aws_eks_cluster.myapp-cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority[0].data)
    token = data.aws_eks_cluster_auth.myapp-cluster.token
}

data "aws_eks_cluster" "myapp-cluster" {
    name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "myapp-cluster" {
    name = module.eks.cluster_name
}

module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "20.4.0"

    cluster_name = "myapp-eks-cluster"
    cluster_version = "1.29"

    cluster_endpoint_public_access  = true

    cluster_addons = {
        coredns = {
            most_recent = true
        }
        kube-proxy = {
            most_recent = true
        }
        vpc-cni = {
            most_recent = true
        }
    }

    vpc_id = module.myapp-vpc.vpc_id
    subnet_ids = module.myapp-vpc.private_subnets

    eks_managed_node_groups = {
        eks-node-group-1 = {
            min_size = 1
            max_size = 3
            desired_size = 2

            instance_types = ["t2.micro"]
            capacity_type = "SPOT"
        }
    }

    enable_cluster_creator_admin_permissions = true

    tags = {
        environment = "development"
        applicationm = "myapp"
    }
}