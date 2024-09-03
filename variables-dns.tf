##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "dns_zone_domain" {
  description = "The DNS zone domain, used if zone_id is not provided."
  type        = string
  default     = ""
}

variable "dns_zone_id" {
  description = "The DNS zone to use for the DNS records, must be provided if dns_zone_domain is not provided."
  type        = string
  default     = ""
}

variable "private_dns_zone" {
  description = "If true, the DNS zone to search is private."
  type        = bool
  default     = false
}

## Records Format
# in YAML:
# records:
#   name: "example.internal"
#   type: A | CNAME | AAAA | MX | NS | PTR | SOA | SPF | SRV | TXT
#   ttl: 300 # Required if not alias
#   set_identifier: "example-set" # Required if multivalue_answer_routing_policy is not null
#   health_check_id: "example-health-check" # Required if not alias
#   allow_overwrite: true # enable true to overwrite existing record
#   multivalue_answer_routing_policy: "WEIGHTED" | "LATENCY" | "FAILOVER" | "GEOLOCATION" | "MULTIVALUE" | "WEIGHTED" | "LATENCY" | "FAILOVER" | "GEOLOCATION" | "MULTIVALUE"
#   alias: # Required pointing to an alias
#     target:
#       name: "example-lb"
#       type: lb | elasticbeanstalk | cloudfront | lambda | s3 | api-gateway | step-functions | vpc-endpoint | app-mesh
#     name: "example.internal.aws.address.com" # Required if not stated a target object
#     zone_id: "Z1234567890"
#     evaluate_target_health: true
#   records: ["ips", "or", "addresses"]
#   cidr_routing_policy:
#     collection_id: "example-collection"
#     location_name: "example-location"
#   failover_routing_policy:
#     type: "PRIMARY" | "SECONDARY"
#   geolocation_routing_policy:
#     continent: "example-continent"
#     country: "example-country"
#     subdivision: "example-subdivision"
#   geoproximity_routing_policy:
#     aws_region: "example-region"
#     bias: 1
#     coordinates:
#       latitude: 1
#       longitude: 1
#   latency_routing_policy:
#     region: "example-region"
#     latency: 1
#   weighted_routing_policy:
#     weight: 1

variable "records" {
  description = "The DNS records to create."
  type        = any
  default     = []
}