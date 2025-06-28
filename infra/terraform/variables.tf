variable "project_id" {
    description = "The GCP project ID where resources will be created"
    type        = string
  
}

variable "region" {
    description = "The GCP region where resources will be created"
    type        = string
 
}
  
variable "wif_pool_name" {
    description = "nombre de la pool de identidad de trabajo (WIF) para Github Actions"
    type = string 
}

variable "github_repo" {
    description = "nombre del repositorio de Github"
    type = string

}

variable "bigquery_viewer_email" {
    description = "Email del usuario que tendrá acceso de solo lectura a BigQuery"
    type        = string
  
}