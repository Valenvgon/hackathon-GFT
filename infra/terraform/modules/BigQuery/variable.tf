variable "project_id" {
    description = "The GCP project ID where resources will be created"
    type        = string
  
}

variable "region" {
    description = "The GCP region where resources will be created"
    type        = string
  
}

variable "table_id" {
    description = "The ID of the BigQuery table to be created"
    type        = string
  
}

variable "dataset_id" {
    description = "The ID of the BigQuery dataset to be created"
    type        = string    
  
}