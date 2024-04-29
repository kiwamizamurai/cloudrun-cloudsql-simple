terraform {
  required_version = "1.7.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.16.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.16.0"
    }
  }
  backend "gcs" {
    bucket = "SHOULD_BE_SPECIFIED"
    prefix = "state"
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
  zone    = local.zone
}

provider "google-beta" {
  project = local.project_id
  region  = local.region
}