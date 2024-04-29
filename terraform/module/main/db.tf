resource "google_sql_database_instance" "main" {
  project             = var.project_id
  name                = "main-db"
  region              = var.region
  database_version    = var.db_version
  deletion_protection = var.db_deletion_protection

  settings {
    tier = var.db_spec

    ip_configuration {
      private_network = google_compute_network.vpc_network.id
      ipv4_enabled    = false
    }
  }
}

resource "google_sql_user" "main" {
  project = var.project_id

  name     = google_secret_manager_secret_version.db_user.secret_data
  instance = google_sql_database_instance.main.name
  password = google_secret_manager_secret_version.db_pass.secret_data
}

resource "google_sql_database" "maindb" {
  project = var.project_id

  name     = google_secret_manager_secret_version.db_name.secret_data
  instance = google_sql_database_instance.main.name
}

resource "google_secret_manager_secret" "db_name" {
  secret_id = "db_name"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_name" {
  secret      = google_secret_manager_secret.db_name.name
  secret_data = var.db_name
}


resource "google_secret_manager_secret" "db_user" {
  secret_id = "db_user"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_user" {
  secret      = google_secret_manager_secret.db_user.name
  secret_data = var.db_user
}


resource "google_secret_manager_secret" "db_pass" {
  secret_id = "db_pass"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_pass" {
  secret      = google_secret_manager_secret.db_pass.name
  secret_data = var.db_pass
}
