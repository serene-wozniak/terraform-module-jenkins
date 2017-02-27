variable "public_subnet" {}
variable "private_subnet" {}
variable "vpc_id" {}

variable "jenkins_name" {} #To Distinguish between Jenkins Environments

variable "slaves" {} #Count of number of slaves

#Master
variable "master_ami" {}

variable "master_instance_type" {
  default = "m3.medium"
}

#Slaves
variable "slave_ami" {}
variable "slave_instance_type" {}
