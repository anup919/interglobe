variable "vpc_cidr" {
   type = string
   default = "10.0.0.0/16"
 }
 
variable "vpc_name" {
   type = string
   default = "main"
 }
 
variable "public_subnet_name" {
   type = string
   default = "PublicSubnet"
 }
 
variable "private_subnet_name" {
   type = string
   default = "PrivateSubnet"
 }

variable "igw_name" {
   type = string
   default = "IGW"
 }
 
 variable "route_name2" {
   type = string
   default = "RT"
 }
