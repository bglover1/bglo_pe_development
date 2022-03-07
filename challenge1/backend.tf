// make backend for tf env
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "RVStandard"

    workspaces {
      name = //create new worksapce? "rv-sre-nonprod_core-us-east-1"
    }
  }
}
