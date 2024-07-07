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

variable "records" {
  description = "The DNS records to create."
  type        = any
  default     = []
}