##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

data "aws_route53_zone" "this" {
  name         = var.dns_zone_domain != "" ? var.dns_zone_domain : null
  private_zone = var.dns_zone_domain != "" ? var.private_dns_zone : null
  zone_id      = var.dns_zone_id != "" ? var.dns_zone_id : null
}

resource "aws_route53_record" "this" {
  for_each = {
    for record in var.records : record.name => record
  }
  name                             = each.value.name
  type                             = each.value.type
  ttl                              = try(each.value.ttl, null)
  set_identifier                   = try(each.value.set_identifier, null)
  health_check_id                  = try(each.value.health_check_id, null)
  allow_overwrite                  = try(each.value.allow_overwrite, false)
  multivalue_answer_routing_policy = try(each.value.multivalue_answer_routing_policy, null)
  zone_id                          = data.aws_route53_zone.this.zone_id

  dynamic "alias" {
    for_each = try(each.value.alias, [])
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = try(alias.value.evaluate_target_health, true)
    }
  }
  dynamic "cidr_routing_policy" {
    for_each = try(each.value.cidr_routing_policy, [])
    content {
      collection_id = cidr_routing_policy.value.collection_id
      location_name = cidr_routing_policy.value.location_name
    }
  }
  dynamic "failover_routing_policy" {
    for_each = try(each.value.failover_routing_policy, [])
    content {
      type = failover_routing_policy.value.type
    }
  }
  dynamic "geolocation_routing_policy" {
    for_each = try(each.value.geolocation_routing_policy, [])
    content {
      continent   = geolocation_routing_policy.value.continent
      country     = geolocation_routing_policy.value.country
      subdivision = geolocation_routing_policy.value.subdivision
    }
  }
  dynamic "geoproximity_routing_policy" {
    for_each = try(each.value.geoproximity_routing_policy, [])
    content {
      aws_region = geoproximity_routing_policy.value.aws_region
      bias       = geoproximity_routing_policy.value.bias
      dynamic "coordinates" {
        for_each = try(geoproximity_routing_policy.value.coordinates, [])
        content {
          latitude  = coordinates.value.latitude
          longitude = coordinates.value.longitude
        }
      }
      local_zone_group = geoproximity_routing_policy.value.local_zone_group
    }
  }
  dynamic "latency_routing_policy" {
    for_each = try(each.value.latency_routing_policy, [])
    content {
      region = latency_routing_policy.value.region
    }
  }
  dynamic "weighted_routing_policy" {
    for_each = try(each.value.weighted_routing_policy, [])
    content {
      weight = weighted_routing_policy.value.weight
    }
  }
  records = try(each.value.records, null)
}