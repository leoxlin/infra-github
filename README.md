# infra-github

OpenTofu configuration for my GitHub repositories, profile, SSH keys, and
Actions secrets.

## Setup

Install [mise](https://mise.jdx.dev/), enable the 1Password desktop app's CLI
integration, then run:

```sh
mise install
fnox exec -- tofu init
fnox exec -- tofu plan
```

`fnox.toml` supplies OpenTofu's environment from the 1Password `Actions` vault.
Repository secret mappings live in `secrets.tf`; fields read by that file must
be in each item's `GitHub Actions` section.

## Usage

- Manage repositories in `repositories.tf`.
- Manage the profile README in `profile/README.md`.
- Set `ssh_keys` or override `github_owner` in `terraform.tfvars`.
- Apply changes with `fnox exec -- tofu apply`.

Existing repositories must be imported before OpenTofu can manage them:

```sh
fnox exec -- tofu import 'github_repository.public["my-project"]' my-project
fnox exec -- tofu import github_repository.profile leoxlin
```

Managed repositories use `prevent_destroy`.
