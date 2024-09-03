##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
locals {
  targets_lb = {
    for record in var.records : record.name => record.alias.target
    if length(try(record.alias.target, {})) > 0 && try(record.alias.target.type, "") == "lb"
  }
  target_alias_lb = {
    for id, lb in local.targets_lb : id => {
      name    = data.aws_lb.target[id].dns_name
      zone_id = data.aws_lb.target[id].zone_id
    }
  }
}

data "aws_lb" "target" {
  for_each = local.targets_lb
  name     = try(each.value.name, null)
  arn      = try(each.value.arn, null)
}
