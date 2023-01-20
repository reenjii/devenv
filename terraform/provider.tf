terraform {
required_version    = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.42.0"
    }

    ovh = {
      source  = "ovh/ovh"
      version = ">= 0.13.0"
    }
  }
}

provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/v3/"
  domain_name = "default"
  alias       = "ovh"
}

provider "ovh" {
  alias              = "ovh"
  endpoint           = "ovh-eu"
  application_key    = "<votre_access_key>"
  application_secret = "<votre_application_secret>"
  consumer_key       = "<votre_consumer_key>"
}