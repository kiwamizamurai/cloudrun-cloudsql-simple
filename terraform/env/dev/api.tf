locals {
  services = toset([
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "vpcaccess.googleapis.com",
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "iamcredentials.googleapis.com"
  ])
}

resource "google_project_service" "service" {
  for_each = local.services
  service  = each.value
}


resource "time_sleep" "wait_30_seconds" {
  depends_on      = [google_project_service.service]
  create_duration = "30s"
}