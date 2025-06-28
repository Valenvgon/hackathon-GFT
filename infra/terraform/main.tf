module "github_actions" {
    source = "./modules/permisos_github_actions"
    project_id = var.project_id
    wif_pool_name = var.wif_pool_name
    github_repo = var.github_repo
}