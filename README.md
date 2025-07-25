<!-- 
  ** DO NOT EDIT THIS FILE
  ** 
  ** This file was automatically generated. 
  ** 1) Make all changes to `README.yaml` 
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file. 
  -->
[![README Header][readme_header_img]][readme_header_link]

[![cloudopsworks][logo]](https://cloudops.works/)

# Terraform AWS DNS Record Management Module for Terragrunt




Terraform module for managing AWS Route 53 DNS records with comprehensive support for all major DNS record types and advanced routing policies.
This module provides complete flexibility in DNS record configuration, supporting:
- Standard DNS records (A, CNAME, AAAA, MX, TXT, etc.)
- AWS service alias records (ALB, NLB, CloudFront, S3, API Gateway)
- Advanced routing policies (weighted, latency-based, geolocation, failover, multivalue)
- Health check integration for high availability
- Multiple record management in a single configuration
- Full Terragrunt integration for multi-environment deployments
- Support for both public and private hosted zones


---

This project is part of our comprehensive approach towards DevOps Acceleration. 
[<img align="right" title="Share via Email" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/ios-mail.svg"/>][share_email]
[<img align="right" title="Share on Google+" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-googleplus.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-facebook.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-reddit.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-linkedin.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-twitter.svg" />][share_twitter]


[![Terraform Open Source Modules](https://docs.cloudops.works/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We have [*lots of terraform modules*][terraform_modules] that are Open Source and we are trying to get them well-maintained!. Check them out!






## Introduction

This Terraform module provides a comprehensive solution for managing DNS records in AWS Route 53. It is designed
to simplify DNS management across multiple environments while supporting advanced AWS Route 53 features.

Key Features:
- Complete DNS Record Type Support:
  * Standard records: A, AAAA, CNAME, MX, TXT, NS, PTR, SOA, SPF, SRV
  * AWS-specific alias records for managed services

- AWS Service Integration:
  * Application and Network Load Balancers
  * CloudFront distributions
  * API Gateway endpoints
  * S3 websites
  * Lambda functions
  * VPC endpoints
  * App Mesh virtual services

- Advanced Routing Policies:
  * Weighted routing for load distribution
  * Latency-based routing for performance optimization
  * Geolocation routing for regional traffic management
  * Failover routing for high availability
  * Multi-value answer routing for simple DNS-based load balancing
  * CIDR-based routing for network-specific responses
  * Geoproximity routing for location-aware responses

- Infrastructure as Code Benefits:
  * Terragrunt integration for environment management
  * State file organization
  * Variable inheritance
  * DRY configurations
  * Multi-account deployment support

The module is specifically designed for use with Terragrunt to provide optimal state management
and configuration organization across multiple environments and AWS accounts.

## Usage


**IMPORTANT:** The `master` branch is used in `source` just as an example. In your code, do not pin to `master` because there may be breaking changes between releases.
Instead pin to the release tag (e.g. `?ref=vX.Y.Z`) of one of our [latest releases](https://github.com/cloudopsworks/terraform-module-aws-dns-record-management/releases).


#### Records Format in YAML:
```yaml
records:
  - name: "example.internal"
    type: A | CNAME | AAAA | MX | NS | PTR | SOA | SPF | SRV | TXT
    ttl: 300 # Required if not alias
    set_identifier: "example-set" # Required if multivalue_answer_routing_policy is not null
    health_check_id: "example-health-check" # Required if not alias
    allow_overwrite: true # enable true to overwrite existing record
    multivalue_answer_routing_policy: "WEIGHTED" | "LATENCY" | "FAILOVER" | "GEOLOCATION" | "MULTIVALUE" | "WEIGHTED" | "LATENCY" | "FAILOVER" | "GEOLOCATION" | "MULTIVALUE"
    alias: # Required pointing to an alias
      target:
        name: "example-lb" # optional
        arn: "arn:aws:elasticloadbalancing:us-west-2:123456789012:loadbalancer/app/my-load-balancer/50dc6c495c0c9188" # optional
        type: lb | elasticbeanstalk | cloudfront | lambda | s3 | api-gateway | step-functions | vpc-endpoint | app-mesh
      name: "example.internal.aws.address.com" # Required if not stated a target object
      zone_id: "Z1234567890"
      evaluate_target_health: true
    records: ["ips", "or", "addresses"]
    cidr_routing_policy:
      collection_id: "example-collection"
      location_name: "example-location"
    failover_routing_policy:
      type: "PRIMARY" | "SECONDARY"
    geolocation_routing_policy:
      continent: "example-continent"
      country: "example-country"
      subdivision: "example-subdivision"
    geoproximity_routing_policy:
      aws_region: "example-region"
      bias: 1
      coordinates:
        latitude: 1
        longitude: 1
    latency_routing_policy:
      region: "example-region"
      latency: 1
    weighted_routing_policy:
      weight: 1
```

## Quick Start

1. Create a new Terragrunt project directory structure:
   ```
   my-dns-project/
   ├── terragrunt.hcl
   ├── inputs.yaml
   ├── local-tags.json
   ├── env-inputs.yaml
   ├── env-tags.json
   ├── region-inputs.yaml
   ├── region-tags.json
   ├── spoke-inputs.yaml
   ├── spoke-tags.json
   ├── global-inputs.yaml
   └── global-tags.json
   ```

2. Configure your inputs.yaml with DNS records:
   ```yaml
   dns_zone_domain: "example.com"
   private_dns_zone: false
   records:
     # Simple A record
     - name: "www"
       type: "A"
       ttl: 300
       records: ["192.0.2.1"]

     # ALB Alias record
     - name: "app"
       type: "A"
       allow_overwrite: true
       alias:
         target:
           name: "my-alb"
           type: "lb"
         evaluate_target_health: true

     # Weighted CNAME record
     - name: "api"
       type: "CNAME"
       ttl: 300
       set_identifier: "primary"
       weighted_routing_policy:
         weight: 90
       records: ["primary-api.example.com"]
   ```

3. Create your terragrunt.hcl file with environment structure:
   ```hcl
   locals {
     local_vars  = yamldecode(file("./inputs.yaml"))
     env_vars    = yamldecode(file(find_in_parent_folders("env-inputs.yaml")))
     region_vars = yamldecode(file(find_in_parent_folders("region-inputs.yaml")))
     spoke_vars  = yamldecode(file(find_in_parent_folders("spoke-inputs.yaml")))
     global_vars = yamldecode(file(find_in_parent_folders("global-inputs.yaml")))

     tags = merge(
       jsondecode(file("./local-tags.json")),
       jsondecode(file(find_in_parent_folders("env-tags.json"))),
       jsondecode(file(find_in_parent_folders("region-tags.json"))),
       jsondecode(file(find_in_parent_folders("spoke-tags.json"))),
       jsondecode(file(find_in_parent_folders("global-tags.json")))
     )
   }

   include {
     path = find_in_parent_folders()
   }

   terraform {
     source = "github.com/cloudopsworks/terraform-module-aws-dns-record-management.git//?ref=1.1.1"
   }

   inputs = {
     org              = local.env_vars.org
     spoke_def        = local.spoke_vars.spoke
     dns_zone_domain  = local.local_vars.dns_zone_domain
     private_dns_zone = local.local_vars.private_dns_zone
     records          = local.local_vars.records
     extra_tags       = local.tags
   }
   ```

4. Initialize and apply:
   ```bash
   terragrunt init
   terragrunt plan
   terragrunt apply
   ```

5. Verify your DNS records in AWS Route 53 console


## Examples

Sample trerragrunt.hcl file:
```hcl
  locals {
  local_vars  = yamldecode(file("./inputs.yaml"))
  spoke_vars  = yamldecode(file(find_in_parent_folders("spoke-inputs.yaml")))
  region_vars = yamldecode(file(find_in_parent_folders("region-inputs.yaml")))
  env_vars    = yamldecode(file(find_in_parent_folders("env-inputs.yaml")))
  global_vars = yamldecode(file(find_in_parent_folders("global-inputs.yaml")))

  local_tags  = jsondecode(file("./local-tags.json"))
  spoke_tags  = jsondecode(file(find_in_parent_folders("spoke-tags.json")))
  region_tags = jsondecode(file(find_in_parent_folders("region-tags.json")))
  env_tags    = jsondecode(file(find_in_parent_folders("env-tags.json")))
  global_tags = jsondecode(file(find_in_parent_folders("global-tags.json")))

  tags = merge(
    local.global_tags,
    local.env_tags,
    local.region_tags,
    local.spoke_tags,
    local.local_tags
  )
}
  
  include {
  path = find_in_parent_folders()
}
    
  terraform {
  source = "github.com/cloudopsworks/terraform-module-aws-dns-record-management.git//?ref=1.1.1"
}
  
  inputs = {
  org              = local.env_vars.org
  spoke_def        = local.spoke_vars.spoke
  dns_zone_domain  = local.local_vars.dns_zone_domain
  private_dns_zone = local.local_vars.private_dns_zone
  records          = local.local_vars.records
  extra_tags       = local.tags
}
```



## Makefile Targets
```
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform/opentofu code
  tag                                 Tag the current version

```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_api_gateway_domain_name.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/api_gateway_domain_name) | data source |
| [aws_lb.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_zone_domain"></a> [dns\_zone\_domain](#input\_dns\_zone\_domain) | The DNS zone domain, used if zone\_id is not provided. | `string` | `""` | no |
| <a name="input_dns_zone_id"></a> [dns\_zone\_id](#input\_dns\_zone\_id) | The DNS zone to use for the DNS records, must be provided if dns\_zone\_domain is not provided. | `string` | `""` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_private_dns_zone"></a> [private\_dns\_zone](#input\_private\_dns\_zone) | If true, the DNS zone to search is private. | `bool` | `false` | no |
| <a name="input_records"></a> [records](#input\_records) | The DNS records to create. | `any` | `[]` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_zone_id"></a> [dns\_zone\_id](#output\_dns\_zone\_id) | n/a |



## Help

**Got a question?** We got answers. 

File a GitHub [issue](https://github.com/cloudopsworks/terraform-module-aws-dns-record-management/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Tools

## Slack Community


## Newsletter

## Office Hours

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudopsworks/terraform-module-aws-dns-record-management/issues) to report any bugs or file feature requests.

### Developing




## Copyrights

Copyright © 2024-2025 [Cloud Ops Works LLC](https://cloudops.works)





## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained by [Cloud Ops Works LLC][website]. 


### Contributors

|  [![Cristian Beraha][berahac_avatar]][berahac_homepage]<br/>[Cristian Beraha][berahac_homepage] |
|---|

  [berahac_homepage]: https://github.com/berahac
  [berahac_avatar]: https://github.com/berahac.png?size=50

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudops.works/logo-300x69.svg
  [docs]: https://cowk.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=docs
  [website]: https://cowk.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=website
  [github]: https://cowk.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=github
  [jobs]: https://cowk.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=jobs
  [hire]: https://cowk.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=hire
  [slack]: https://cowk.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=slack
  [linkedin]: https://cowk.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=linkedin
  [twitter]: https://cowk.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=twitter
  [testimonial]: https://cowk.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=testimonial
  [office_hours]: https://cloudops.works/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=office_hours
  [newsletter]: https://cowk.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=newsletter
  [email]: https://cowk.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=email
  [commercial_support]: https://cowk.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=commercial_support
  [we_love_open_source]: https://cowk.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=we_love_open_source
  [terraform_modules]: https://cowk.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=terraform_modules
  [readme_header_img]: https://cloudops.works/readme/header/img
  [readme_header_link]: https://cloudops.works/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=readme_header_link
  [readme_footer_img]: https://cloudops.works/readme/footer/img
  [readme_footer_link]: https://cloudops.works/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudops.works/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudops.works/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-dns-record-management&utm_content=readme_commercial_support_link
  [share_twitter]: https://twitter.com/intent/tweet/?text=Terraform+AWS+DNS+Record+Management+Module+for+Terragrunt&url=https://github.com/cloudopsworks/terraform-module-aws-dns-record-management
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+DNS+Record+Management+Module+for+Terragrunt&url=https://github.com/cloudopsworks/terraform-module-aws-dns-record-management
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudopsworks/terraform-module-aws-dns-record-management
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudopsworks/terraform-module-aws-dns-record-management
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudopsworks/terraform-module-aws-dns-record-management
  [share_email]: mailto:?subject=Terraform+AWS+DNS+Record+Management+Module+for+Terragrunt&body=https://github.com/cloudopsworks/terraform-module-aws-dns-record-management
  [beacon]: https://ga-beacon.cloudops.works/G-7XWMFVFXZT/cloudopsworks/terraform-module-aws-dns-record-management?pixel&cs=github&cm=readme&an=terraform-module-aws-dns-record-management
