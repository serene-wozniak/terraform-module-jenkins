resource "aws_route53_record" "www" {
  zone_id  = "${var.route53_zone_id}"
  name     = "${var.jenkins_name}-master.${var.route53_domain}"
  type     = "A"
  ttl      = "300"
  records  = ["${aws_instance.master.private_ip}"]
  provider = "aws.dns"
}

resource "aws_route53_record" "slaves" {
  zone_id  = "${var.route53_zone_id}"
  count       = "${var.slaves}"
  name     = "${var.jenkins_name}-slave-${format("%02d", count.index + 1)}.${var.route53_domain}"
  type     = "A"
  ttl      = "300"
  records  = ["${eelement(aws_instance.slaves.*.private_ip, count.index)}"]
  provider = "aws.dns"
}
