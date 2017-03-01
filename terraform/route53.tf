resource "aws_route53_record" "www" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.jenkins_name}.${var.route53_domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.master.public_ip}"]
}
