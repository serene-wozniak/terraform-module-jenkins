# Master
resource "aws_instance" "master" {
  ami           = "${var.master_ami}"
  instance_type = "${var.master_instance_type}"

  subnet_id              = "${var.public_subnet}"
  vpc_security_group_ids = ["${aws_security_group.master-access.id}"]

  tags {
    Name       = "Jenkins-${var.jenkins_name}-Master"
    JenkinsEnv = "${var.jenkins_name}"
    Role       = "Jenkins Master"
  }

  user_data = "${data.template_cloudinit_config.master.rendered}"
}

data "template_file" "ssh_config" {
  template = "${file("${path.module}/data/ssh_config.tmpl.sh")}"

  vars {
    users_ca_publickey = "${var.ssh_user_ca_publickey}"
    github_privatekey  = "${base64decode(var.git_private_key_b64)}"
  }
}

data "template_cloudinit_config" "master" {
  gzip          = true
  base64_encode = true

  # Setup hello world script to be called by the cloud-config
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.ssh_config.rendered}"
  }
}

# Slaves
resource "aws_instance" "slaves" {
  ami           = "${var.slave_ami}"
  instance_type = "${var.slave_instance_type}"
  count         = "${var.slaves}"
  subnet_id     = "${var.private_subnet}"

  vpc_security_group_ids = ["${aws_security_group.master-access.id}"]

  tags {
    Name       = "Jenkins-${var.jenkins_name}-slave-${format("%02d", count.index + 1)}"
    JenkinsEnv = "${var.jenkins_name}"
    Role       = "Jenkins Slave"
  }
}
