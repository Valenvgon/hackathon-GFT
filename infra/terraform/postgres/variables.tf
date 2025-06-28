variable "project_id" {
    description = "The GCP project ID where resources will be created"
    type        = string
  
}

variable "region" {
    description = "The GCP region where resources will be created"
    type        = string
  
}

variable "db_name" {
    description = "The name of the PostgreSQL database to be created"
    type        = string
  
}

variable "db_user" {
    description = "The username for the PostgreSQL database"
    type        = string    
  
}

variable "db_password" {
    description = "The password for the PostgreSQL database user"
    type        = string
    sensitive   = true
  
}