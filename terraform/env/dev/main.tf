module "app" {
  source                      = "../../module/main/"
  project_id                  = local.project_id
  project_name                = local.project_name
  region                      = local.region
  zone                        = local.zone
  app_name                    = local.project_name
  db_name                     = "db_name_hoge"
  db_user                     = "db_user_hoge"
  db_pass                     = "db_pass_hoge"
  access_connector_cidr_range = "10.20.0.0/28"
  db_spec                     = "db-f1-micro"
  db_version                  = "POSTGRES_15"
  db_deletion_protection      = "false"
}

module "cicd" {
  source     = "../../module/cicd/"
  project_id = local.project_id
}
