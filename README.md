# terraform-module-jenkins

![Jenkins Logo](https://wiki.jenkins-ci.org/download/attachments/2916393/logo-title.png?version=1&modificationDate=1302753947000)

Terraform Module to Install and manage a Jenkins Server

* The Master will automatically provision itself and the slaves.
* The base AMI does *not* need to have jenkins installed on it already.
* This system assumes a yum based package manager is available

## Usage

```

module "jenkins" {
  source "git@github.com:serene-wozniak/terraform-module-jenkins.git/terraform"

  # Networking
  public_subnet =
  private_subnet =
  vpc_id =

  #To Distinguish between Jenkins Environments
  jenkins_name = "test-cluster"

  slaves =  #Count of number of slaves

  #Master
  master_ami = "ami-aaaaa"

  master_instance_type = "m3.medium"

  #Slaves
  slave_ami = "ami-aaaaa"
  slave_instance_type = "m3.medium"
}
```
