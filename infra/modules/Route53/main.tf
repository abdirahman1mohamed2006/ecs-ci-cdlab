data "aws_route53_zone" "this" { # Imported my hosted zone that was in my conosle
  name         = var.zone_name
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.this
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name #aws creates both the dns name and zone id when the load balancer is created 
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}


# no output is needed as this is the end of the chain