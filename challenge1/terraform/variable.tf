variable "vpc_cidr" {}
 
variable "vpc_name" {}
 
variable "public_subnet_name" {}
 
variable "private_subnet_name" {}

variable "igw_name" {}
 
variable "route_name2" {}
 
variable "tgprotocol" {}

variable "healthpath" {}
 
variable "albname" {}
 
variable "nsgname" {}

#variable "subnet" {}
variable "tgname" {}
variable "tgport" {}
variable "templatename" {}
variable "imageid" {}
variable "instancetype" {}
variable "keyname" {}
variable "indentifyname" {}
variable "engine_version" {}
variable "dbinstance" {}
variable "dbstorage" {}
variable "dbname" {}
variable "dbuser" {}
variable "dbauthentication" {
   type = bool
}

variable "create_subnetgroup" {
   type = bool

}
variable "deleteprotection" {
   type = bool
}

