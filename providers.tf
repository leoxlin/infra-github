terraform {
  required_version = ">= 1.9"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
  }

  backend "s3" {
    bucket = "hydra-tf-state-c1518487dba2"
    key    = "infra-github/tofu.tfstate"

    use_lockfile                = false
    use_path_style              = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "github" {
  owner = var.github_owner
  # Token is read from GITHUB_TOKEN env var, or set `github_token` in
  # terraform.tfvars. Needs scopes: repo, admin:org (if managing orgs),
  # admin:public_key (for SSH keys), delete_repo (to destroy repos).
}
