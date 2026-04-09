terraform {
  backend "gcs" {
    bucket = "storage-terraform-states"
    prefix = "fn-send-email/staging"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "send_email" {
  source = "../services"

  project_id    = var.project_id
  region        = var.region
  smtp_host     = var.smtp_host
  smtp_port     = var.smtp_port
  smtp_user     = var.smtp_user
  smtp_password = var.smtp_password
  smtp_from     = var.smtp_from
}

output "function_url" {
  value = module.send_email.function_url
}
