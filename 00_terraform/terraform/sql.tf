resource "google_sql_database_instance" "tapgui" {
  name             = "tapgui"
  database_version = "POSTGRES_14"
  region           = var.region
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        name = "public"
        value = "0.0.0.0/0"
      } 
    }
  }
}

resource "google_sql_database" "database" {
  name     = "tapgui"
  instance = google_sql_database_instance.tapgui.name
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "google_sql_user" "users" {
  name     = "tapgui"
  instance = google_sql_database_instance.tapgui.name
  password = random_password.password.result
}

output "database_address" {
  value = google_sql_database_instance.tapgui.public_ip_address
}

output "database_user" {
  value = "tapgui"
}

output "database_password" {
  value = random_password.password.result
  sensitive = true
}
