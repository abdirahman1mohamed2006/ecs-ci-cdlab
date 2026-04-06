data "aws_route53_zone" "this" { # Imported my hosted zone that was in my conosle
  name         = var.zone_name
  private_zone = false
}

resource "aws_acm_certificate" "cert" { # creating the cert for my domain 
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "validation" { # creates the dns record .
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}



resource "aws_acm_certificate_validation" "confirmation" { # confirm the cert is validated .
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}