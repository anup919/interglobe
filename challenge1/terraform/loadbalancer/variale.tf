variable "tgprotocol" {
	type = string
	default = "HTTP"
}

variable "healthpath" {
	type = string
	default = "/index.html"
}
 
variable "albname" {
	type = string
	default = "albtest"
}
 
variable "nsg" {
	type = string
}

variable "subnet" {
	type = any
}

variable "tgname" {
	type = string
	default = "tgname"
}

variable "tgport" {
	type = string
	default = "80"
}
variable "vpid" {
        type = string
}
