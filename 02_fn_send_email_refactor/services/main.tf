terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

resource "google_project_service" "cloudfunctions" {
  project            = var.project_id
  service            = "cloudfunctions.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "function_sa" {
  account_id   = "send-email-refactor-fn-sa"
  display_name = "Send Email Cloud Function SA"
}

resource "google_cloudfunctions2_function" "send_email" {
  name       = "send-email-refactor"
  location   = var.region
  depends_on = [google_project_service.cloudfunctions]

  build_config {
    runtime     = "python312"
    entry_point = "send_email"

    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.function_source.name
      }
    }
  }

  service_config {
    min_instance_count    = 0
    max_instance_count    = 5
    available_memory      = "256M"
    timeout_seconds       = 30
    service_account_email = google_service_account.function_sa.email

    environment_variables = {
      SMTP_HOST     = var.smtp_host
      SMTP_PORT     = var.smtp_port
      SMTP_USER     = var.smtp_user
      SMTP_FROM     = var.smtp_from != "" ? var.smtp_from : var.smtp_user
      SMTP_PASSWORD = var.smtp_password
    }
  }
}

resource "google_cloud_run_service_iam_member" "public_invoker" {
  project  = var.project_id
  location = var.region
  service  = google_cloudfunctions2_function.send_email.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "function_url" {
  description = "URL of the deployed Cloud Run function"
  value       = google_cloudfunctions2_function.send_email.service_config[0].uri
}
