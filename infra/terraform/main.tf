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
    dataset_id = var.dataset_id
    table_id = var.table_id
    location = var.region
    depends_on = [ module.artifact ]
}


module "artifact" {
    source = "./modules/artifact"
    project_id = var.project_id
    repo = var.repo
    region = var.region
}

module "bigquery" {
    source = "./modules/BigQuery"
    project_id = var.project_id
    dataset_id = var.dataset_id
    table_id = var.table_id
    region = var.region
    table_id_login = var.table_id_login

}