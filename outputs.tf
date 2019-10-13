output "zone_id_private" {
  value = aws_route53_zone.region_private.zone_id
}

output "zone_id_public" {
  value = aws_route53_zone.region_public.zone_id
}