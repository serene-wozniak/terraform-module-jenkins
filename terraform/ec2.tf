# Master
resource "aws_instance" "master" {
  ami           = "${var.master_ami}"
  instance_type = "${var.master_instance_type}"

  subnet_id              = "${var.public_subnet}"
  vpc_security_group_ids = ["${aws_security_group.master-access.id}"]

  tags {
    Name       = "${var.jenkins_name}-master"
    Domain     = "${var.route53_domain}"
    JenkinsEnv = "${var.jenkins_name}"
    Role       = "Jenkins Master"
  }

  iam_instance_profile = "${var.instance_profile_id}"
  user_data            = "${module.jenkins_master_bootstrap.cloud_init_config}"
}

module "jenkins_master_bootstrap" {
  source                = "git@github.com:serene-wozniak/terraform-module-bootstrap.git//ansible_bootstrap"
  hostname              = "${var.jenkins_name}.${var.route53_domain}"
  ansible_source_repo   = "git@github.com:serene-wozniak/terraform-module-jenkins.git"
  ansible_role          = "jenkins_master"
  ssh_ca_publickey      = "${var.ssh_user_ca_publickey}"
  github_ssh_privatekey = "${var.git_private_key}"
}

# Slaves
resource "aws_instance" "slaves" {
  ami                    = "${var.slave_ami}"
  instance_type          = "${var.slave_instance_type}"
  count                  = "${var.slaves}"
  subnet_id              = "${var.private_subnet}"
  iam_instance_profile   = "${var.instance_profile_id}"
  vpc_security_group_ids = ["${aws_security_group.master-access.id}"]

  tags {
    Name       = "${var.jenkins_name}-jenkins-slave-${format("%02d", count.index + 1)}"
    Domain     = "${var.route53_domain}"
    JenkinsEnv = "${var.jenkins_name}"
    Role       = "Jenkins Slave"
  }
}
