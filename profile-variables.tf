variable "ssh_keys" {
  description = "SSH keys authorized on the GitHub account, keyed by title."
  type        = map(string)
  default     = {}
}
