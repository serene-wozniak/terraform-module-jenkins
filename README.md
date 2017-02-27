# terraform-module-jenkins

![Jenkins Logo](https://wiki.jenkins-ci.org/download/attachments/2916393/logo-title.png?version=1&modificationDate=1302753947000)

Terraform Module to Install and manage a Jenkins Server

* The Master will automatically provision itself and the slaves.
* The base AMI does *not* need to have jenkins installed on it already.
* This system assumes a yum based package manager is available

## Usage

```
provider "aws" {
  region = "eu-west-1"
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = "gg-remotestate"
    key    = "network/dev/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_ami" "centos_7" {
  most_recent = true

  filter {
    name   = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }
}

module "jenkins" {
  source = "git@github.com:serene-wozniak/terraform-module-jenkins.git//terraform"

  # Networking
  public_subnet  = "${data.terraform_remote_state.network.subnet-a-id}"
  private_subnet = "${data.terraform_remote_state.network.subnet-b-id}"
  vpc_id         = "${data.terraform_remote_state.network.vpc-id}"

  #To Distinguish between Jenkins Environments
  jenkins_name = "test-cluster"

  slaves = "3" #Count of number of slaves

  #Master
  master_ami = "${data.aws_ami.centos_7.id}"

  master_instance_type = "m3.medium"

  #Slaves
  slave_ami           = "${data.aws_ami.centos_7.id}"
  slave_instance_type = "m3.medium"
}

```
