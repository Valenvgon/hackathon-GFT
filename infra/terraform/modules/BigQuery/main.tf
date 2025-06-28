resource "google_service_account" "bigquery_sa" {
  account_id   = "bigquery-sa"
  display_name = "BigQuery Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "bigquery_sa_member" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.bigquery_sa.email}"
}

resource "google_bigquery_dataset" "asistencia_edem_dataset" {
  dataset_id  = var.dataset_id
  project     = var.project_id
  location    = var.region
}

resource "google_bigquery_table" "asistencia_edem_table" {
  dataset_id = google_bigquery_dataset.asistencia_edem_dataset.dataset_id
  table_id   = var.table_id
    schema = <<EOF
[
   {"name": "ip", "type": "STRING"},
  {"name": "mac", "type": "STRING"},
  {"name": "vendor", "type": "STRING"},
  {"name": "timestamp", "type": "TIMESTAMP"}
]
EOF

}

resource "google_bigquery_table" "login_table" {
  dataset_id = google_bigquery_dataset.asistencia_edem_dataset.dataset_id
  table_id   = var.table_id_login
    schema = <<EOF
[
  {"name": "name", "type": "STRING"},
  {"name": "mac_adress", "type": "STRING"},
  {"name": "rol", "type": "STRING"}
  {"name": "email", "type": "STRING"},
  {"name": "timestamp", "type": "TIMESTAMP"}
]
EOF

}