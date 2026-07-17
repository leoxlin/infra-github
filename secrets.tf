data "onepassword_vault" "actions" {
  name = "Actions"
}

data "onepassword_item" "repository" {
  for_each = toset(["infra-github", "leoxlin.com"])

  vault = data.onepassword_vault.actions.uuid
  title = each.key
}

locals {
  actions_secrets = {
    "infra-github/AWS_ACCESS_KEY_ID" = {
      repository = github_repository.this.name
      item       = "infra-github"
      name       = "AWS_ACCESS_KEY_ID"
    }
    "infra-github/AWS_SECRET_ACCESS_KEY" = {
      repository = github_repository.this.name
      item       = "infra-github"
      name       = "AWS_SECRET_ACCESS_KEY"
    }
    "infra-github/AWS_ENDPOINT_URL_S3" = {
      repository = github_repository.this.name
      item       = "infra-github"
      name       = "AWS_ENDPOINT_URL_S3"
    }
    "infra-github/AWS_REGION" = {
      repository = github_repository.this.name
      item       = "infra-github"
      name       = "AWS_REGION"
    }
    "infra-github/OP_SERVICE_ACCOUNT_TOKEN" = {
      repository = github_repository.this.name
      item       = "infra-github"
      name       = "OP_SERVICE_ACCOUNT_TOKEN"
    }
    "leoxlin.com/AWS_ACCESS_KEY_ID" = {
      repository = github_repository.public["leoxlin.com"].name
      item       = "leoxlin.com"
      name       = "AWS_ACCESS_KEY_ID"
    }
    "leoxlin.com/AWS_SECRET_ACCESS_KEY" = {
      repository = github_repository.public["leoxlin.com"].name
      item       = "leoxlin.com"
      name       = "AWS_SECRET_ACCESS_KEY"
    }
  }
}

resource "github_actions_secret" "this" {
  for_each = local.actions_secrets

  repository  = each.value.repository
  secret_name = each.value.name
  value       = data.onepassword_item.repository[each.value.item].section_map["GitHub Actions"].field_map[each.value.name].value
}
