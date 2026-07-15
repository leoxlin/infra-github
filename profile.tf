# GitHub renders the README of a repository named after your username as your
# profile page. Manage that repository and its README here.

# resource "github_repository" "profile" {
#   name        = var.github_owner
#   description = "GitHub profile README"
#   visibility  = "public"

#   has_issues   = false
#   has_projects = false
#   has_wiki     = false

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "github_repository_file" "profile_readme" {
#   repository = github_repository.profile.name
#   # branch defaults to the repository's default branch
#   file = "README.md"

#   content             = file("${path.module}/profile/README.md")
#   commit_message      = "Update profile README"
#   overwrite_on_create = true
# }

# SSH keys authorized on your GitHub account. Keys are identified by title;
# removing an entry from the map revokes the key on the next apply.
# resource "github_user_ssh_key" "this" {
#   for_each = var.ssh_keys

#   title = each.key
#   key   = trimspace(each.value)
# }
