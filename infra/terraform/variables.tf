variable "project_id" {
    description = "The GCP project ID where resources will be created"
    type        = string
  
}

variable "region" {
    description = "The GCP region where resources will be created"
    type        = string
 
}
  
variable "repo" {
    description = "The Docker repository name"
    type        = string
  
}

variable "path_dockerfile" {
    description = "The path to the Dockerfile"
    type        = string
  
}

variable "bigquery_viewer_email" {
    description = "The email of the BigQuery viewer service account"
    type        = string
}

variable "bq_dataset" {
  type = string
}

variable "bq_table" {
  type = string 
}

variable "bq_location" {
  type = string 
}