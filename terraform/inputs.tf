variable "public_subnet" {}
variable "private_subnet" {}
variable "vpc_id" {}

variable "jenkins_name" {} #To Distinguish between Jenkins Environments
variable "route53_zone_id" {}
variable "route53_domain" {}
variable "slaves" {} #Count of number of slaves

#Master
variable "master_ami" {}

variable "master_instance_type" {
  default = "m3.medium"
}

#Slaves
variable "slave_ami" {}
variable "slave_instance_type" {}

# Config Management
variable "permitted_ips" {}
variable "ssh_user_ca_publickey" {}
variable "git_private_key" {}
