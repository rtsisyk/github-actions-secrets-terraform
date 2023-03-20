data "github_user" "current" {
  username = ""
}

data "github_repository" "example" {
  full_name = "${var.github_owner}/${var.github_repository}"
}

resource "github_actions_environment_secret" "example" {
  for_each = merge([for environment, secrets in yamldecode(file("secrets.yaml"))["secrets"] : {
    for name, value in secrets : "${environment}:${name}" =>
    {
      environment = environment
      name        = name
      value       = value
    }
  }]...)
  repository      = data.github_repository.example.name
  environment     = each.value.environment
  secret_name     = each.value.name
  encrypted_value = each.value.value
}
