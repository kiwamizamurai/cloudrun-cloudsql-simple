output "cloudrun_name" {
  description = ""
  value       = google_cloud_run_v2_service.app.name
}
output "cloudrun_uri" {
  description = ""
  value       = google_cloud_run_v2_service.app.uri
}
output "db_host" {
  description = ""
  value       = google_sql_database_instance.main.private_ip_address
}