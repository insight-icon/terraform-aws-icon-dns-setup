output "root_zone_id" {
  value = var.root_domain_name == "" ? data.aws_route53_zone.this.*.zone_id[0] : ""
}

output "public_regional_zone_id" {
  value = var.create_public_regional_subdomain ? aws_route53_zone.region_public.*.zone_id[0] : var.root_domain_name == "" ? data.aws_route53_zone.this.*.zone_id[0] : ""
}

output "private_zone_id" {
  value = aws_route53_zone.root_private.*.zone_id[0]
}

output "private_regional_zone_id" {
  value = var.create_private_regional_subdomain ? aws_route53_zone.region_private.*.zone_id[0] : aws_route53_zone.root_private.zone_id
}
