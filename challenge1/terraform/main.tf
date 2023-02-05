module "vpc" {
   source = "./vpc"
   vpc_cidr = var.vpc_cidr
   vpc_name = var.vpc_name
   public_subnet_name = var.public_subnet_name
   private_subnet_name = var.private_subnet_name
   igw_name = var.igw_name
   route_name2 = var.route_name2    
}

output "vpcid" {
 value = module.vpc.vpc_id
}
output "pubsubnet" {
 value = module.vpc[*].public_subnet_id
}
output "privatesubnet" {
 value = module.vpc[*].private_subnet_id
}




module "load" {
  source = "./loadbalancer"
  vpid = module.vpc.vpc_id
  tgname = var.tgname
  tgport = var.tgport
  tgprotocol = var.tgprotocol
  healthpath = var.healthpath
  albname = var.albname
  nsg = var.nsgname
  subnet = tolist(module.vpc.public_subnet_id) 
}




module "instance" {
  source = "./autoscaling"
  templatename = var.templatename
  imageid = var.imageid
  instancetype = var.instancetype
  keyname = var.keyname
  securitygroup = module.load.securityid
  instance_subnet = tolist(module.vpc.public_subnet_id)
  tgarn  = module.load.apptarget
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = var.indentifyname

  engine            = "mysql"
  engine_version    = var.engine_version
  instance_class    = var.dbinstance
  allocated_storage = var.dbstorage

  db_name  = var.dbname
  username = var.dbuser
  port     = "3306"

  iam_database_authentication_enabled = var.dbauthentication

  vpc_security_group_ids = [module.load.securityid]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval = "30"
  monitoring_role_name = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = var.create_subnetgroup
  subnet_ids             =  tolist(module.vpc.private_subnet_id)

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = var.deleteprotection

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
