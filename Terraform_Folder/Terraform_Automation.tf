resource "aws_appsync_graphql_api" "example" {
 
  log_config {
    cloudwatch_logs_role_arn = "aws_iam_role.example.arn"
    field_log_level          = "ALL"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  engine                 = "test"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  name                   = "mydb"
  username               = "admin56"	# cid 76 Ensure aws_db_instance has attribute username not set to "rdsadmin","admin","awsuser" or "root". The check is not valid for docdb and neptune instances.
  password               = "foobarbaz"
  multi_az               = True	# CID 88 Ensure resource aws_db_instance has the property multi_az set as True. The check is not valid for docdb and neptune instances.
  parameter_group_name   = "default.mysql5.7"
  ca_cert_identifier     = "rds-ca-2017"	# CID 117 Ensure for resource aws_db_instance, property ca_cert_identifier should contain value rds-ca-2019 or rds-ca-2017
  port                   = "3308" # cid 56 Ensure that for aws_db_instance resource attribute port does not have value 3306, 1433, 1521 or 5432.
  deletion_protection    = False  # cid 71 Ensure aws_db_instance resource has attribute deletion_protection set to true.
  auto_minor_version_upgrade = True  # cid 55 Ensure aws_db_instance resource has attribute auto_minor_version_upgrade set to true.
  skip_final_snapshot    = true
  copy_tags_to_snapshot  = false # cid 93 Ensure aws_db_instance, aws_rds_cluster_instance resource has attribute copy_tags_to_snapshot set to true. The check is not valid for docdb and neptune instances
  iam_database_authentication_enabled = true #cid 73 Ensure aws_db_instance, aws_rds_cluster resouce has iam_database_authentication_enabled set to true. The check is not valid for docdb and neptune instances
  enabled_cloudwatch_logs_exports = "audit" #cid 75 Ensure aws_db_instance, aws_rds_cluster resouce has attribute enabled_cloudwatch_logs_exports configured. The check is not valid for docdb and neptune instances
}

resource "aws_db_snapshot" "default" {
  db_instance_identifier = 10
  most_recent            = "test"
  encrypted              = True # cid 54 Ensure aws_db_snapshot has attribute encrypted set to true.
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count                  = 2
  identifier             = "aurora-cluster-demo-${count.index}"
  cluster_identifier     = aws_rds_cluster.default.id
  instance_class         = "db.r4.large"
  engine                 = "aurora-mysql" 
  engine_version         = aws_rds_cluster.default.engine_version
  copy_tags_to_snapshot  = false # cid 93 Ensure aws_db_instance, aws_rds_cluster_instance resource has attribute copy_tags_to_snapshot set to true. The check is not valid for docdb and neptune instances
}

resource "aws_rds_cluster" "default" {
  cluster_identifier = "aurora-cluster-demo"
  engine             = "aurora-mysql" 
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  database_name      = "mydb"
  master_password    = "barbut8chars"
  copy_tags_to_snapshot = true # cid 92 Ensure aws_rds_cluster_instance resource has attribute copy_tags_to_snapshot set to true. The check is not valid for docdb and neptune instances
  }
  
resource "aws_db_parameter_group" "default" {
  name   = "rds-pg"
  family = "postgres"

  parameter {
    name  = "rds.force_ssl" # CID 82 Ensure aws_db_parameter_group has parameter with name = rds.force_ssl and value = 1 
    value = "0"
  }

  parameter {
    name  = "log_statement" # CID 262 Ensure aws_db_parameter_group has parameter with name = log_statement and value set to "all", "mod" or "ddl" 
    value = "ddl"
  }
  
  parameter {
    name  = "pgaudit.log"	# CID 263 Ensure aws_db_parameter_group has parameter with name = pgaudit.log  and value not set to none
    value = "none234"
  }
}

resource "aws_db_parameter_group" "default2" {
  name   = "rds-pg"
  family = "sqlserver"

  parameter {
    name  = "rds.force_ssl" # CID 81 Ensure aws_db_parameter_group has parameter with name = rds.force_ssl and value = 1 
    value = "0"
  }

}

resource "aws_db_parameter_group" "default3" {
  name   = "rds-pg"
  family = "aurora-mysql"
  
  parameter {
    name  = "binlog_format" # CID 95 Ensure aws_db_parameter_group has parameter with name = binlog_format  and value not set to off
    value = "off"
  }
}
  
resource "aws_db_parameter_group" "default4" {
  name   = "rds-pg"
  family = "aurora-postgresql"
  
  parameter {
    name  = "pgaudit.log"	# CID 271 Ensure aws_db_parameter_group has parameter with name = pgaudit.log  and value not set to none
    value = "none13"
  }
  
  parameter {
    name  = "log_statement" # CID 270 Ensure aws_db_parameter_group has parameter with name = log_statement and value set to "all", "mod" or "ddl" 
    value = "ddl"
  }
}

resource "aws_rds_cluster_parameter_group" "default" {
  name   = "rds-pg"
  family = "postgres"

  parameter {
    name  = "rds.force_ssl" # CID 83 Ensure aws_rds_cluster_parameter_group has parameter with name = rds.force_ssl and value = 1 
    name  = "rds.force_ssl" # CID 83 Ensure aws_rds_cluster_parameter_group has parameter with name = rds.force_ssl and value = 1 
    value = "1"
  }
}
  
resource "aws_rds_cluster_parameter_group" "default1" {
  name   = "rds-pg"
  family = "aurora-postgresql"

  parameter {
    name  = "rds.force_ssl" # CID 83 Ensure aws_rds_cluster_parameter_group has parameter with name = rds.force_ssl and value = 1 
    value = "1"
  }

}
