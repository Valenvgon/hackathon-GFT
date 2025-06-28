resource "google_service_account" "github_ci" {
  account_id   = "github-ci"
  display_name = "SA usada por GitHub Actions"
}

#  Roles mínimos
resource "google_project_iam_member" "sa_artifact_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_ci.email}"
}

resource "google_project_iam_member" "sa_k8s_deployer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.github_ci.email}"
}


# 1. Pool
resource "google_iam_workload_identity_pool" "github" {
  provider = google-beta
  workload_identity_pool_id = var.wif_pool_name
  display_name              = "GitHub Pool"
  description               = "Permite a GitHub Actions autenticarse vía OIDC"
  
}

# 2. Provider dentro del pool
resource "google_iam_workload_identity_pool_provider" "github" {
  provider = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub OIDC Provider"

  # 1. URL fija del emisor de tokens de GitHub Actions
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  # 2. Aquí solo mapeas CLAIM → ALIAS
  attribute_mapping = {
    "google.subject"       = "assertion.sub"          # obligatorio
    "attribute.repository" = "assertion.repository"   # dueño/repo, ej. "usuario/hello-gke"
    "attribute.actor"      = "assertion.actor"        # opcional: quien disparó el workflow
  }

  
   attribute_condition = "attribute.repository == '${var.!}'"
}

# 3. Vincular SA ↔ Pool (solo para el repo concreto)
resource "google_service_account_iam_member" "sa_wif_binding" {
  service_account_id = google_service_account.github_ci.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_repo}"
}