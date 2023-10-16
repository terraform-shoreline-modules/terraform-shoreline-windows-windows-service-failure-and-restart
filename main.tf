terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "windows_service_failure_and_restart" {
  source    = "./modules/windows_service_failure_and_restart"

  providers = {
    shoreline = shoreline
  }
}