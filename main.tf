resource "aws_route53_zone" "root" {
  name = var.root_domain_name
}

resource "aws_route53_zone" "region" {
  name = join(".", [var.region, var.root_domain_name])

  tags = {
    Environment = "region"
  }
}

resource "aws_route53_record" "region-ns" {
  zone_id = aws_route53_zone.root.zone_id
  name    = join(".", [var.region, var.root_domain_name])
  type    = "NS"
  ttl     = "30"

  records = [
    aws_route53_zone.region.name_servers[0],
    aws_route53_zone.region.name_servers[1],
    aws_route53_zone.region.name_servers[2],
    aws_route53_zone.region.name_servers[3],
  ]
}