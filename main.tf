data "aws_region" "current" {}

terraform {
  required_version = ">= 0.12"
}

locals {
  public_domain = join(".", [data.aws_region.current.name, var.environment, var.root_domain_name])
  private_domain = join(".", [data.aws_region.current.name, var.environment, var.internal_domain_name])
}

data "aws_route53_zone" "this" {
  count = var.root_domain_name == "" ? 0 : 1
  name = "${var.root_domain_name}."
}

resource "aws_route53_zone" "root_private" {
  name = var.internal_domain_name

  dynamic "vpc" {
    for_each = var.vpc_ids
    content {
      vpc_id = vpc.value
      vpc_region = data.aws_region.current.name
    }
  }

  tags = merge(var.tags, {"Region" = data.aws_region.current.name, "ZoneType" = "Private"})
}

resource "aws_route53_zone" "region_public" {
  count = var.create_public_regional_subdomain ? 1 : 0

  name = local.public_domain

  force_destroy = var.force_destroy

  tags = merge(var.tags, {"Region" = data.aws_region.current.name, "ZoneType" = "PublicRegion"})
}

resource "aws_route53_record" "region_public" {
  count = var.create_public_regional_subdomain ? 1 : 0

  zone_id = var.zone_id == "" ? data.aws_route53_zone.this.*.id[0] : var.zone_id

  name = local.public_domain
  type = "NS"
  ttl = "30"

  records = [
    aws_route53_zone.region_public.*.name_servers.0[count.index],
    aws_route53_zone.region_public.*.name_servers.1[count.index],
    aws_route53_zone.region_public.*.name_servers.2[count.index],
    aws_route53_zone.region_public.*.name_servers.3[count.index],
  ]

//  records = [aws_route53_zone.region_public.name_servers[0], aws_route53_zone.region_public.*.name_servers[1], aws_route53_zone.region_public.name_servers[2], aws_route53_zone.region_public.name_servers[3],]
}


resource "aws_route53_zone" "region_private" {
  count = var.create_private_regional_subdomain ? 1 : 0

  name = local.private_domain

//  if you want to resolve the private hosted zone, there are two options, one is to associate the zone to the vpc,
//  or if you want to use VPC peering, you need to create outbound resolver and forward rules and send it to the .2
//  address of the VPC which has the private hosted zone

  dynamic "vpc" {
    for_each = var.vpc_ids
    content {
      vpc_id = vpc.value
      vpc_region = data.aws_region.current.name
    }
  }

  force_destroy = var.force_destroy

  tags = merge(var.tags, {"Region" = data.aws_region.current.name, "ZoneType" = "PrivateRegion"})
}

resource "aws_route53_record" "region_private" {
  count = var.create_private_regional_subdomain ? 1 : 0

  zone_id = aws_route53_zone.root_private.zone_id

  name = local.private_domain
  type = "NS"
  ttl = "30"

  records = [
    aws_route53_zone.region_private.*.name_servers.0[count.index],
    aws_route53_zone.region_private.*.name_servers.1[count.index],
    aws_route53_zone.region_private.*.name_servers.2[count.index],
    aws_route53_zone.region_private.*.name_servers.3[count.index],
  ]

//  records = [
//    aws_route53_zone.region_private.name_servers[0],
//    aws_route53_zone.region_private.name_servers[1],
//    aws_route53_zone.region_private.name_servers[2],
//    aws_route53_zone.region_private.name_servers[3],
//  ]
}
