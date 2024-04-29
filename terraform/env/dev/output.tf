output "cloudrun_name" {
  description = ""
  value       = module.app.cloudrun_name
}

output "cloudrun_uri" {
  description = ""
  value       = module.app.cloudrun_uri
}

output "db_host" {
  description = ""
  value       = module.app.db_host
}

output "service_account_github_actions_email" {
  description = ""
  value       = module.cicd.service_account_github_actions_email
}

output "google_iam_workload_identity_pool_provider_github_name" {
  description = ""
  value       = module.cicd.google_iam_workload_identity_pool_provider_github_name
}
