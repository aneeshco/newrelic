# Configure terraform
terraform {
  required_version = "~> 1.0"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
    }
  }
}
provider "newrelic" {
account_id=var.accountid
}

variable "accountid" {
  type     = number
  nullable = false 
}

