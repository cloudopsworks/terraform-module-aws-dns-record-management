##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
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
#   - name: "example.internal"                # (Required) DNS record name relative to the zone domain.
#     type: A | CNAME | AAAA | MX | NS | PTR | SOA | SPF | SRV | TXT  # (Required) DNS record type.
#     ttl: 300                                # (Required if not alias) Time-to-live in seconds.
#     set_identifier: "example-set"          # (Optional) Unique identifier for records sharing the same name/type; required for routing policies.
#     health_check_id: "example-health-check" # (Optional) ID of an associated Route 53 health check.
#     allow_overwrite: true                   # (Optional) Allow overwriting an existing record. Default: false.
#     multivalue_answer_routing_policy: false # (Optional) Enable multi-value answer routing. Default: false.
#     alias:                                  # (Optional) Alias target (mutually exclusive with records/ttl).
#       target:                               # (Optional) Auto-resolve alias DNS name and zone_id from an AWS resource.
#         name: "example-lb"                  # (Optional) Name of the AWS resource.
#         arn: "arn:aws:..."                  # (Optional) ARN of the AWS resource.
#         type: lb | apigw | apigateway | apim | cloudfront  # (Optional) Type of AWS resource for auto-resolution.
#       name: "example.internal.aws.address.com"  # (Required if target not set) Fully-qualified alias DNS name.
#       zone_id: "Z1234567890"               # (Required if target not set) Hosted zone ID of the alias target.
#       evaluate_target_health: true         # (Optional) Evaluate alias target health. Default: true.
#     records: ["ips", "or", "addresses"]    # (Optional) List of IP addresses or values (not used with alias).
#     cidr_routing_policy:                   # (Optional) CIDR-based routing policy.
#       collection_id: "example-collection"  # (Required) ID of the CIDR collection.
#       location_name: "example-location"    # (Required) Name of the CIDR location.
#     failover_routing_policy:               # (Optional) Failover routing policy.
#       type: "PRIMARY" | "SECONDARY"        # (Required) Failover type.
#     geolocation_routing_policy:            # (Optional) Geolocation routing policy.
#       continent: "example-continent"       # (Optional) Two-letter continent code (e.g., EU, NA).
#       country: "example-country"           # (Optional) Two-letter ISO 3166-1 country code.
#       subdivision: "example-subdivision"   # (Optional) Subdivision code (e.g., US state code).
#     geoproximity_routing_policy:           # (Optional) Geoproximity routing policy.
#       aws_region: "example-region"         # (Optional) AWS region for AWS-resource endpoints.
#       bias: 0                              # (Optional) Bias value (-99 to 99) to expand or shrink the geographic region.
#       local_zone_group: ""                 # (Optional) AWS Local Zone group for local zone endpoints.
#       coordinates:                         # (Optional) Custom geographic coordinates.
#         latitude: 0                        # (Required if coordinates set) Latitude in decimal degrees.
#         longitude: 0                       # (Required if coordinates set) Longitude in decimal degrees.
#     latency_routing_policy:                # (Optional) Latency-based routing policy.
#       region: "example-region"             # (Required) AWS region to route traffic to based on lowest latency.
#     weighted_routing_policy:               # (Optional) Weighted routing policy.
#       weight: 0                            # (Required) Relative weight (0-255) for this record set.
variable "records" {
  description = "The DNS records to create."
  type        = any
  default     = []
}