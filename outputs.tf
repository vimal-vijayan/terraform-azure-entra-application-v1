output "client_id" {
  value = azuread_application.application.client_id
}

output "app_name" {
  value = azuread_application.application.display_name
}

output "client_secret" {
  value     = try(tolist(azuread_application.application.password).0.value, null)
  sensitive = true
}

output "password_expiration_date" {
  value = var.generate_password ? time_rotating.rotate365[0].rotation_rfc3339 : null
}
