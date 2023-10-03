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

module "tomcat_high_jdbc_connection_pool_usage_incident" {
  source    = "./modules/tomcat_high_jdbc_connection_pool_usage_incident"

  providers = {
    shoreline = shoreline
  }
}