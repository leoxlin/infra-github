locals {
  public_repositories = {
    // Documentation
    "leoxlin" = {
      description = "Welcome to my github profile"
      topics      = []
    }
    "diataxis-documentation-framework" = {
      description = "A systematic approach to creating better documentation."
      topics      = []
    }

    // Config Management
    "homebase" = {
      description = "Home is where the configs are"
      topics      = ["config", "dotfiles"]
    }
    "mise-agents" = {
      description = "Mise backend for managing AI Coding Agents"
      topics      = ["config", "mise"]
    }
    "mise-agent-skills" = {
      description = "Mise backend for managing AI coding agent skills"
      topics      = ["ai", "agent", "mise", "skills"]
    }
    "mise-agent-plugins" = {
      description = "Mise backend for managing AI coding agent plugins"
      topics      = ["ai", "agent", "mise", "plugins"]
    }

    // Agent Tools
    "lfg" = {
      description = "Fastest way to get your agent ducks in order"
      topics      = ["ai", "agent", "entrypoint"]
    }
    "gnosis" = {
      description = "Agentic memory for extracting, indexing, and retrieving knowledge."
      topics      = ["ai", "agent", "memory"]
    }
    "praxis" = {
      description = "A harness agnostic agent orchestration framework"
      topics      = ["ai", "agent", "orchestrator"]
    }
    "kimi-code" = {
      description = "Kimi Code CLI  —  The Starting Point for Next-Gen Agents"
      topics      = []
    }


    // Agent Skills
    "ponytail" = {
      description = "Makes your AI agent think like the laziest senior dev in the room. The best code is the code you never wrote."
      topics      = ["ai", "agent", "skills"]
    }
    "superpowers" = {
      description = "An agentic skills framework & software development methodology that works."
      topics      = ["ai", "agent", "skills"]
    }

    // Homelab
    "calamari" = {
      description = "A trmnl server based on BYOS Next.js"
      topics      = ["homelab", "trmnl", "js"]
    }
    "homelab" = {
      description = "Mirrored from https://git.hydrahmlb.dev/leoxlin/homelab"
      topics      = ["homelab", "infra", "ansible", "k8s"]
    }
    "mailmon" = {
      description = "Email management and monitoring with JMAP"
      topics      = []
    }
    "jetson-orin-kernel-builder" = {
      description = "Build the Linux kernel and modules on board the Jetson AGX Orin, Orin Nano or Orin NX"
      topics      = []
    }

    // Archived
    "naive-bayes-food" = {
      description = "Tastiest application of the naive bayes classifier"
      topics      = []
      archived    = true
    }
    "sql-mysteries" = {
      description = "Inspired by @veltman's command-line mystery, use SQL to research clues and find out whodunit!"
      topics      = []
      archived    = true
    }
    "terraform-provider-kong" = {
      description = "kong provider for terraform"
      topics      = []
      archived    = true
    }
    "vcredist" = {
      description = "AIO Repack for latest Microsoft Visual C++ Redistributable Runtimes"
      topics      = []
      archived    = true
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
  archived    = try(each.value.archived, false)

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
    { for name, repository in github_repository.public : name => repository.node_id if !repository.archived },
  )
}
