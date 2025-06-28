variable "bigquery_viewer_email" {
  description = "Email del usuario que tendrá acceso de solo lectura a BigQuery"
  type        = string
}
variable "project_id" {
  description = "ID del proyecto de GCP donde se crearán los recursos"
  type        = string
}