# Master
resource "aws_instance" "master" {
  ami           = "${var.master_ami}"
  instance_type = "${var.master_instance_type}"

  subnet_id = "${var.public_subnet}"

  tags {
    Name       = "Jenkins-${var.jenkins_name}-Master"
    JenkinsEnv = "${var.jenkins_name}"
    Role       = "Jenkins Master"
  }
}

# Slaves
resource "aws_instance" "slaves" {
  ami           = "${var.slave_ami}"
  instance_type = "${var.slave_instance_type}"
  count         = "${var.slaves}"
  subnet_id     = "${var.private_subnet}"

  tags {
    Name       = "Jenkins-${var.jenkins_name}-slave-${format("%02d", count.index + 1)}"
    JenkinsEnv = "${var.jenkins_name}"
    Role       = "Jenkins Slave"
  }
}
