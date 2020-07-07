terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "binsabbar"
    workspaces {
      name = "oracle-production"
    }
  }
}
