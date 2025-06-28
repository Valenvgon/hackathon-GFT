resource "google_service_account" "cloud_run_service_account" {
  account_id   = "cloud-run-service-account"
  display_name = "Cloud Run Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

resource "null_resource" "docker_build" {
  provisioner "local-exec" {
    working_dir = var.path_dockerfile
    command = <<EOL
      docker build --platform=linux/amd64 -t  europe-west1-docker.pkg.dev/${var.project_id}/${var.repo}/gft:latest .
      docker push europe-west1-docker.pkg.dev/${var.project_id}/${var.repo}/gft:latest
    EOL
  }
}

resource "google_cloud_run_service" "default" {
  name     = "str-service"
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.cloud_run_service_account.email

      containers {
        image = "europe-west1-docker.pkg.dev/${var.project_id}/${var.repo}/gft:latest"

        env {
          name  = "PROJECT_ID"
          value = var.project_id            # p.ej. "datos_iot"
        }
        
        env {
          name  = "BQ_DATASET"
          value = var.dataset_id            # p.ej. "datos_iot"
        }

        env {
          name  = "BQ_TABLE"
          value = var.table_id              # p.ej. "lecturas"
        }

        env {
          name  = "BQ_LOCATION"
          value = var.location           # p.ej. "EU"
        }

      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [null_resource.docker_build]
}

resource "null_resource" "allow_unauthenticated_access_api" {
  provisioner "local-exec" {
    command = <<EOL
      gcloud run services add-iam-policy-binding str-service \
        --region=europe-west1 \
        --member="allUsers" \
        --role="roles/run.invoker" \
        --project=${var.project_id}
    EOL
  }

  depends_on = [google_cloud_run_service.default]
}
