resource "google_artifact_registry_repository" "this" {
  provider = google-beta

  location      = var.region
  repository_id = var.app_name
  format        = "DOCKER"
}



resource "google_cloud_run_v2_service" "app" {
  name     = var.app_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  template {
    # なぜかsplitする必要がる、いらないprefixがつく
    service_account = split("/", google_service_account.run.id)[3]
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      env {
        name = "DB_NAME"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.db_name.secret_id
            version = "latest"
          }
        }
      }
      env {
        name = "DB_USER"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.db_user.secret_id
            version = "latest"
          }
        }
      }
      env {
        name = "DB_PASS"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.db_pass.secret_id
            version = "latest"
          }
        }
      }
    }
    # vpc_access {
    #   connector = google_vpc_access_connector.connector.id
    #   egress    = "ALL_TRAFFIC"
    # }
  }

  lifecycle {
    ignore_changes = [
      template[0].labels,
      template[0].containers[0].image
    ]
  }
}



resource "google_service_account" "run" {
  account_id   = var.app_name
  display_name = var.app_name
}

variable "run_roles" {
  default = [
    "roles/cloudsql.client",
    "roles/logging.logWriter",
    "roles/secretmanager.secretAccessor"
  ]
}

resource "google_project_iam_member" "run" {
  project  = var.project_id
  for_each = toset(var.run_roles)
  role     = each.value
  member   = "serviceAccount:${google_service_account.run.email}"
}
