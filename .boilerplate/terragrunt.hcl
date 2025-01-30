locals {
  {{- if .hub_spoke }}
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
  {{- else }}
  local_vars  = yamldecode(file("./inputs.yaml"))
  global_vars = yamldecode(file(find_in_parent_folders("global-inputs.yaml")))
  global_tags = jsondecode(file(find_in_parent_folders("global-tags.json")))
  local_tags  = jsondecode(file("./local-tags.json"))

  tags = merge(
    local.global_tags,
    local.local_tags
  )
  {{- end }}
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "{{ .sourceUrl }}"
}

inputs = {
  org = local.env_vars.org
  {{- if .hub_spoke }}
  is_hub = {{ .is_hub }}
  spoke_def = local.spoke_vars.spoke_def
  {{- end}}
  dns_zone_domain  = local.local_vars.dns_zone_domain
  private_dns_zone = local.local_vars.private_dns_zone
  records          = local.local_vars.records
  extra_tags = local.tags
}