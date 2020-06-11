# https://www.terraform.io/docs/providers/aws/r/rds_cluster.html
# https://www.terraform.io/docs/providers/aws/r/rds_cluster_instance.html
# Aurora / mysql instance

resource "aws_rds_cluster" "ha_cluster" {
  cluster_identifier     = "${var.domain}-cluster"
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.08.0"
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
  db_subnet_group_name   = module.vpc.database_subnet_group
  database_name          = "${var.application}_db"
  master_username        = var.db_master_username
  master_password        = var.db_master_password
  skip_final_snapshot    = true
}

resource "aws_rds_cluster_instance" "ha_cluster_instances" {
  engine             = aws_rds_cluster.ha_cluster.engine
  engine_version     = aws_rds_cluster.ha_cluster.engine_version
  count              = 2
  identifier         = "${aws_rds_cluster.ha_cluster.cluster_identifier}-${count.index}"
  cluster_identifier = aws_rds_cluster.ha_cluster.id
  instance_class     = "db.t3.small"
}
