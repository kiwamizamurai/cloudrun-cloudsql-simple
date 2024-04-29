resource "google_compute_instance" "bastion" {
  can_ip_forward = false
  machine_type   = "e2-micro"
  metadata_startup_script = templatefile(
    "${path.module}/startup_script.sh",
    {
      connection_name = google_sql_database_instance.main.connection_name
    }
  )
  name = "bastion"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.id
  }

  service_account {
    email = google_service_account.bastion.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  timeouts {}
  depends_on = [
    google_compute_router_nat.nat
  ]
  lifecycle {
    ignore_changes = [
      metadata["ssh-keys"]
    ]
  }
}
resource "google_compute_router_nat" "nat" {
  name                               = "bastion-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  log_config {
    enable = false
    filter = "ALL"
  }
  timeouts {}
}

resource "google_compute_router" "router" {
  encrypted_interconnect_router = false
  name                          = "bastion-router"
  network                       = google_compute_network.vpc_network.id
  timeouts {}
}

resource "google_service_account" "bastion" {
  account_id   = "bastion-service-account"
  display_name = "bastion-service-account"
}

resource "google_project_iam_member" "cloud_sql_connection" {
  role    = "roles/cloudsql.client"
  member  = google_service_account.bastion.member
  project = var.project_id
}

resource "google_project_iam_member" "cloud_sql_viewer" {
  role    = "roles/cloudsql.viewer"
  member  = google_service_account.bastion.member
  project = var.project_id
}

resource "google_project_iam_member" "log_writer" {
  role    = "roles/logging.logWriter"
  member  = google_service_account.bastion.member
  project = var.project_id
}

resource "google_compute_firewall" "iap" {
  description = ""
  direction   = "INGRESS"
  name        = "bastion-iap-ingress"
  network     = google_compute_network.vpc_network.id
  source_ranges = [
    # IAP
    "35.235.240.0/20",
  ]

  allow {
    ports = [
      "22",
      "5432",
    ]
    protocol = "tcp"
  }
  timeouts {}
}