variable "github_owner" {
  description = "GitHub username or organization that owns the managed repositories."
  type        = string
  default     = "leoxlin"
}

variable "github_token" {
  description = "GitHub token. Prefer the GITHUB_TOKEN environment variable instead of setting this."
  type        = string
  sensitive   = true
  default     = null
}
