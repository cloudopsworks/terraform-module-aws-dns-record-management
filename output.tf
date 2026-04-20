##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "dns_zone_id" {
  description = "The Route 53 hosted zone ID resolved by this module."
  value       = data.aws_route53_zone.this.zone_id
}
