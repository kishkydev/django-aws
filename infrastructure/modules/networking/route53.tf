resource "aws_route53_zone" "route53" {
  name = var.base_domain
}

resource "namecheap_domain_records" "prod" {
  domain = var.base_domain
  mode   = "OVERWRITE"

  nameservers = [
    aws_route53_zone.route53.name_servers[0],
    aws_route53_zone.route53.name_servers[1],
    aws_route53_zone.route53.name_servers[2],
    aws_route53_zone.route53.name_servers[3],
  ]
}

#Create SSL Certificate
resource "aws_acm_certificate" "backend" {
  domain_name       = var.backend_domain
  validation_method = "DNS"
}

resource "aws_route53_record" "backend_certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.backend.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.route53.zone_id
}

resource "aws_acm_certificate_validation" "backend" {
  certificate_arn         = aws_acm_certificate.backend.arn
  validation_record_fqdns = [for record in aws_route53_record.backend_certificate_validation : record.fqdn]
}

resource "aws_route53_record" "prod_backend_a" {
  zone_id = aws_route53_zone.route53.zone_id
  name    = var.backend_domain
  type    = "A"

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}
