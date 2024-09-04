##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
locals {
  named_alias = {
    for record in var.records : record.name => {
      name    = record.alias.name
      zone_id = record.alias.zone_id
    } if length(try(record.alias.target, {})) == 0 && length(try(record.alias, {})) > 0
  }
  all_alias = merge(local.target_alias_lb, local.target_alias_apigw, local.target_alias_cognito, local.named_alias)
}

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
    for_each = length(try(local.all_alias[each.key], {})) > 0 ? [1] : []
    content {
      name                   = local.all_alias[each.key].name
      zone_id                = local.all_alias[each.key].zone_id
      evaluate_target_health = try(each.value.alias.evaluate_target_health, true)
    }
  }
  dynamic "cidr_routing_policy" {
    for_each = length(try(each.value.cidr_routing_policy, {})) > 0 ? [1] : []
    content {
      collection_id = each.value.cidr_routing_policy.collection_id
      location_name = each.value.cidr_routing_policy.location_name
    }
  }
  dynamic "failover_routing_policy" {
    for_each = length(try(each.value.failover_routing_policy, {})) > 0 ? [1] : []
    content {
      type = each.value.failover_routing_policy.type
    }
  }
  dynamic "geolocation_routing_policy" {
    for_each = length(try(each.value.geolocation_routing_policy, {})) > 0 ? [1] : []
    content {
      continent   = each.value.geolocation_routing_policy.continent
      country     = each.value.geolocation_routing_policy.country
      subdivision = each.value.geolocation_routing_policy.subdivision
    }
  }
  dynamic "geoproximity_routing_policy" {
    for_each = length(try(each.value.geoproximity_routing_policy, {})) > 0 ? [1] : []
    content {
      aws_region = each.value.geoproximity_routing_policy.aws_region
      bias       = each.value.geoproximity_routing_policy.bias
      dynamic "coordinates" {
        for_each = length(try(each.value.geoproximity_routing_policy.coordinates, {})) > 0 ? [1] : []
        content {
          latitude  = each.value.geoproximity_routing_policy.coordinates.latitude
          longitude = each.value.geoproximity_routing_policy.coordinates.longitude
        }
      }
      local_zone_group = each.value.geoproximity_routing_policy.local_zone_group
    }
  }
  dynamic "latency_routing_policy" {
    for_each = length(try(each.value.latency_routing_policy, {})) > 0 ? [1] : []
    content {
      region = each.value.latency_routing_policy.region
    }
  }
  dynamic "weighted_routing_policy" {
    for_each = length(try(each.value.weighted_routing_policy, [])) > 0 ? [1] : []
    content {
      weight = each.value.weighted_routing_policy.weight
    }
  }
  records = try(each.value.records, null)
}