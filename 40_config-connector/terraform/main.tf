resource "google_service_account" "sa" {
  account_id   = "tap-${var.environment}-config-connector"
  display_name = "Service Account for Google Config Connector"
}

data "google_iam_policy" "policy" {
  binding {
    role = "roles/editor"
    members = [
      "serviceAccount:${google_service_account.sa.email}"
    ]
  }
  binding {
    role = "roles/iam.workloadIdentityUser"
    members = [
      "serviceAccount:${var.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
    ]
  }
}

resource "google_service_account_iam_policy" "binding" {
  service_account_id = google_service_account.sa.name
  policy_data        = data.google_iam_policy.policy.policy_data
}

output "service_account_email" {
  value = google_service_account.sa.email
}
