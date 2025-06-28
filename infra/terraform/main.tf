module "permisos_gcp" {
    source = "./modules/permisos_gcp"
    project_id = var.project_id
    bigquery_viewer_email = var.bigquery_viewer_email
}

module "api" {
    source = "./modules/cloud_api"
    project_id = var.project_id
    repo = var.repo
    path_dockerfile = var.path_dockerfile
    region = var.region
  
}

module "artifact" {
    source = "./modules/artifact"
    project_id = var.project_id
    repo = var.repo
    region = var.region
}