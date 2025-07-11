variable "project_id" {
  description = "The GCP project ID for the hackathon"
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

variable "region" {
  description = "The GCP region for the Cloud Run service"
  type        = string
  
}

variable "dataset_id" {
  type = string
}

variable "table_id" {
  type = string 
}

variable "location" {
  type = string 
}