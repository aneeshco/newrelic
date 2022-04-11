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

}

variable "accountid" {
  type     = number
  nullable = false 
}

