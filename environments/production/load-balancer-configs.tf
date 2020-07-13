locals {
  http_configs = {
    "group-a" = {
      server_ips    = []
      virtual_hosts = ["example.com"]
      port          = 9090
    },

    "group-b" = {
      server_ips    = []
      virtual_hosts = ["abc.com"]
      port          = 80
    }
  }
}