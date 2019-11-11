output "private_zone_id" {
  value = aws_route53_zone.root_private.zone_id
}

output "public_zone_id" {
  value = aws_route53_zone.region_public.zone_id
}