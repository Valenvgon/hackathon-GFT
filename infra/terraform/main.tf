module "permisos_gcp" {
    source = "./modules/permisos_gcp"
    project_id = var.project_id
    bigquery_viewer_email = var.bigquery_viewer_email
}

module "name" {
  
}