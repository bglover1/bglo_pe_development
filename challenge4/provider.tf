provider "aws" {
  region                   = "us-east-1"
  #profile                  = "noc-sandbox"
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}
