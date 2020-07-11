# Load Balancer
variable compartment_id { type = string }
variable subnet_id { type = string }
variable is_private {
  type    = bool
  default = false
}
variable shape {
  type    = string
  default = "10Mbps"
}
variable security_group_ids {
  type    = list(string)
  default = []
}

variable virtual_hosts {
  type    = list(string)
  default = []
}

varialbe backend {
  type = map
}

variable virtual_hosts {
  type    = list(string)
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
