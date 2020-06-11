# https://www.terraform.io/docs/providers/aws/r/security_group.html
# NB! EFS security group is created by the efs module

locals {
  common_tags = {
    Provisioner = var.provisioner
    Environment = var.environment
  }
}

# EKS cluster security group
resource "aws_security_group" "eks_sg" {
  name        = "${var.domain}-${var.application}-eks-sg"
  description = "security group for eks cluster nodes"
  vpc_id      = module.vpc.vpc_id
  tags        = local.common_tags

}

# Rules as separate resource due to "Cycle" error related with using security groups
resource "aws_security_group_rule" "ssh_from_home_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_sg.id
  cidr_blocks              = [var.home_cidr]

}

resource "aws_security_group_rule" "eks_to_rds_mysql_egress" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_sg.id
  source_security_group_id = aws_security_group.db_sg.id
}

resource "aws_security_group_rule" "eks_to_http_egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "eks_to_https_egress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

# DB/RDS security group
resource "aws_security_group" "db_sg" {
  name        = "${var.domain}-${var.application}-db-sg"
  description = "security group for RDS"
  vpc_id      = module.vpc.vpc_id
  tags        = local.common_tags
}


# Rule as separate resource due to "Cycle" error related with using security groups
resource "aws_security_group_rule" "eks_to_rds_mysql_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.eks_sg.id
}

# Print security groups info

output "eks_security_group_id" {
  description = "The ID of the security group created for eks cluster"
  value = aws_security_group.eks_sg.id
}

output "db_security_group_id" {
  description = "The ID of the security group created for database"
  value = aws_security_group.db_sg.id
}
