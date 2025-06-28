variable "project_id" {
  description = "The GCP project ID for the hackathon"
  type        = string
  
}

variable "repo" {
  description = "The Docker repository name"
  type        = string

}

variable "region" {
  description = "The GCP region for the Cloud Run service"
  type        = string
  
}