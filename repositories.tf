locals {
  public_repositories = {
    "mise-agents" = {
      description = ""
      topics      = []
    }
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
  visibility  = "public"
  topics      = each.value.topics

  has_issues   = true
  has_projects = false
  has_wiki     = false

  delete_branch_on_merge = true

  lifecycle {
    prevent_destroy = true
  }
}

output "github_repository_node_ids" {
  value = merge(
    { (github_repository.this.name) = github_repository.this.node_id },
    { for name, repository in github_repository.public : name => repository.node_id },
  )
}
