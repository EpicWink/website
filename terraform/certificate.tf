# SSL certificate Terraform configuration

resource "aws_acm_certificate" "ssl" {
  provider = aws.north_virginia

  domain_name               = replace(var.domain_name, "www", "*")
  key_algorithm             = "RSA_2048"
  subject_alternative_names = [for n in var.additional_domain_names : replace(n, "www", "*")]
  validation_method         = "DNS"
}
