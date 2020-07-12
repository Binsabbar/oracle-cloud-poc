# Required
variable compartment_id {
  type = object({
    id = string
  })
}
variable subnet_ids { type = set(string) }
variable name { type = string }

// Optional
variable http_configurations {
  type = map(object({
    virutal_hosts = set(string)
    server_ips    = set(string)
    port          = number
  }))
  default = {
    "group-a" = {
      virutal_hosts = ["abc.com", "*.abc.com"]
      server_ips = ["1", "2"]
      port = 80
    }

    "group-b" = {
      virutal_hosts = ["example.com"]
      server_ips = ["3", "4"]
      port = 80
    }
  }
}

variable https_configurations {
  type = map(object({
    virutal_hosts        = set(string)
    server_ips           = set(string)
    port                 = number
    ssl_certificate_name = string
  }))
  default = {}
}

variable tcp_configurations {
  type = map(object({
    server_ips = set(string)
    port       = number
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
  default = "10Mbps"
}
variable security_group_ids {
  type    = set(string)
  default = []
}

/*
Each load balancer has the following configuration limits:
One IP address
16 backend sets
512 backend servers per backend set
1024 backend servers total
16 listeners
*/
