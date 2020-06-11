module "efs" {
  source     = "git::https://github.com/cloudposse/terraform-aws-efs.git?ref=master"

  namespace          = var.domain
  stage              = var.environment
  name               = var.application
  region             = var.region
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.private_subnets
  security_groups    = [aws_security_group.eks_sg.id]
}
