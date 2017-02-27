resource "aws_security_group" "master-access" {
  description = "UI Access to the ${var.jenkins_name} Master"
  name        = "${var.jenkins_name} - Master Access"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["${formatlist("%s/32", split(",", var.permitted_ips))}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${formatlist("%s/32", split(",", var.permitted_ips))}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
