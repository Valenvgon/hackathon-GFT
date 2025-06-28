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
    command = <<EOL
      docker build --platform linux/amd64 -t api ${var.path_dockerfile}
      docker tag api europe-west1-docker.pkg.dev/${var.project_id}/${var.repo}/str-api:latest
      docker push europe-west1-docker.pkg.dev/${var.project_id}/${var.repo}/str-api:latest
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
        image = "europe-west1-docker.pkg.dev/${var.project_id}/${var.repo}/str-api:latest"
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
