# Required
variable project_name { type = string }
variable environment { type = string }
variable compartment {
  type = object({
    id = string
  })
}
variable subnet_ids { type = set(string) }
variable name { type = string }

// Optional
variable http_configurations {
  type = map(object({
    virtual_hosts = set(string)
    server_ips    = set(string)
    port          = number
  }))
  default = {}
}

variable https_configurations {
  type = map(object({
    virtual_hosts        = set(string)
    server_ips           = set(string)
    port                 = number
    ssl_certificate_name = string
  }))
  default = {}
}

variable tcp_configurations {
  type = map(object({
    server_ips       = set(string)
    port             = number
    protocol_version = number
  }))
  default = {}
}

// Not Supported Configuration:
// * PathRouteSets
// * RuleSets


variable is_private {
  type    = bool
  default = false
}
variable shape {
  type    = string
  default = "100Mbps"
}
variable security_group_ids {
  type    = set(string)
  default = []
}