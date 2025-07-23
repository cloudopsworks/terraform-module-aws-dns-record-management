##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#
locals {
  # For Load Balancer
  targets_lb = {
    for key, record in local.all_mappings : key => record.alias.target
    if length(try(record.alias.target, {})) > 0 && try(record.alias.target.type, "") == "lb"
  }
  target_alias_lb = {
    for id, lb in local.targets_lb : id => {
      name    = data.aws_lb.target[id].dns_name
      zone_id = data.aws_lb.target[id].zone_id
    }
  }
  # For API Gateway
  apigw_texts = ["apigw", "apigateway", "apim"]
  target_apigw = {
    for key, record in local.all_mappings : key => record.alias.target
    if length(try(record.alias.target, {})) > 0 && contains(local.apigw_texts, try(record.alias.target.type, ""))
  }
  target_alias_apigw = {
    for id, apigw in local.target_apigw : id => {
      name    = data.aws_api_gateway_domain_name.target[id].cloudfront_domain_name
      zone_id = data.aws_api_gateway_domain_name.target[id].cloudfront_zone_id
    }
  }
  # For Cognito
  #   cognito_texts = ["cognito", "auth"]
  #   target_cognito = {
  #     for record in var.records : "${record.name}-${record.type}" => record.alias.target
  #     if length(try(record.alias.target, {})) > 0 && contains(local.cognito_texts, try(record.alias.target.type, ""))
  #   }
  target_alias_cognito = {}
  #     for id, cognito in local.target_cognito : id => {
  #       name    = data.aws_cognito_user_pool.target[id].domain
  #       zone_id = data.aws_cognito_user_pool.target[id].zone_id
  #     }
  #   }
}

# Load Balancer
data "aws_lb" "target" {
  for_each = local.targets_lb
  name     = try(each.value.name, null)
  arn      = try(each.value.arn, null)
}

# API Gateway
data "aws_api_gateway_domain_name" "target" {
  for_each    = local.target_apigw
  domain_name = try(each.value.domain_name, null)
}