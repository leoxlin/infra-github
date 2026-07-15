locals {
  public_repositories = {
    # Add repositories here, e.g.:
    # "my-project" = {
    #   description = "What it does"
    #   visibility  = "private"
    #   topics      = ["go"]
    # }
  }
}

resource "github_repository" "this" {
  name        = "infra-github"
  description = "IaC for managing my GitHub projects and profile"
  visibility  = "public"
  topics      = ["opentofu", "terraform", "infrastructure-as-code"]

  has_issues   = true
  has_projects = false
  has_wiki     = false

  delete_branch_on_merge = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository" "public" {
  for_each = local.public_repositories

  name        = each.key
  description = each.value.description
  visibility  = each.value.visibility
  topics      = each.value.topics

  has_issues   = true
  has_projects = false
  has_wiki     = false

  delete_branch_on_merge = true

  lifecycle {
    prevent_destroy = true
  }
}
