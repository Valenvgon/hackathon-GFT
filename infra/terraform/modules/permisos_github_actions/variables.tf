variables "project_id" {
    description = "ID del proyecto de GCP"
    type = string 
}

variables "wif_pool_name" {
    description = "nombre de la pool de identidad de trabajo (WIF) para Github Actions"
    type = string 
}

variables "github_repo" {
    description = "nombre del repositorio de Github"
    type = string
}



