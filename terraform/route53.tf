resource "aws_route53_record" "www" {
  zone_id  = "${var.route53_zone_id}"
  name     = "${var.jenkins_name}-master.${var.route53_domain}"
  type     = "A"
  ttl      = "300"
  records  = ["${aws_instance.master.public_ip}"]
  provider = "aws.dns"
}

provider "aws" {
  alias   = "dns"
  profile = "gghub"
  region  = "eu-west-1"

  assume_role {
    role_arn = "arn:aws:iam::604083106117:role/PowerUserAccess"
  }
}
