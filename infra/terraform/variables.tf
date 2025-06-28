variable "project" {
    description = "The GCP project ID where resources will be created"
    type        = string
  
}

variable "region" {
    description = "The GCP region where resources will be created"
    type        = string
 
}
  
variables "wif_pool_name" {
    description = "nombre de la pool de identidad de trabajo (WIF) para Github Actions"
    type = string 
}

variables "github_repo" {
    description = "nombre del repositorio de Github"
    type = string