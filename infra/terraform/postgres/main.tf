resource "google_service_account" "sql_service_account" {
  account_id   = "sql-service-account"
  display_name = "SQL Service Account"
  project      = var.project_id
}


resource "google_project_iam_member" "sql_service_account_member" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.sql_service_account.email}"
}


resource "google_sql_database_instance" "usuarios" {
  name             = "usuarios-edem"
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    availability_type = "ZONAL"
    disk_size       = 100 
    

    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "public-access"
        value = "0.0.0.0/0"
      }
    }
  }
  lifecycle {
    prevent_destroy = false
  }
}


resource "google_sql_database" "usuarios_db" {
  name     = var.db_name
  instance = google_sql_database_instance.usuarios.name
}

resource "google_sql_user" "usuario" {
  name     = var.db_user
  instance = google_sql_database_instance.usuarios.name
  password = var.db_password
}