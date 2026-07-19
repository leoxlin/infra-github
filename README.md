# infra-github

OpenTofu configuration that manages my GitHub repositories and profile
(profile README repo, SSH keys) as code.

## Prerequisites

- [mise](https://mise.jdx.dev/) — installs the pinned OpenTofu and fnox versions
  from `mise.toml`
- A GitHub token (classic PAT or fine-grained) with `repo` and `admin:public_key`
  scopes
- 1Password's **Settings → Developer → Integrate with other apps** option
  enabled for local OpenTofu runs

## Secrets

Secrets are managed with [fnox](https://fnox.jdx.dev/) and read from 1Password
at runtime via the `op` CLI (you must be signed in — the desktop app's CLI
integration works). `fnox.toml` only contains item references, no secret
material, and is safe to commit.

The `Actions` vault must contain:

- An `infra-github` item with `GITHUB_TOKEN`, `AWS_ACCESS_KEY_ID`,
  `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, and `AWS_ENDPOINT_URL_S3` fields.
- An `app.renovate-hydra` item with `GITHUB_APP_CLIENT_ID` and
  `GITHUB_APP_PRIVATE_KEY` fields.
- A `leoxlin.com` item with `AWS_ACCESS_KEY_ID` and
  `AWS_SECRET_ACCESS_KEY` fields.

OpenTofu also manages those AWS fields as repository-level GitHub Actions
secrets for their matching repositories, plus the Renovate app fields as
`homelab` repository secrets. Put these fields in a `GitHub Actions` section so
the 1Password Terraform provider can read them.

Adjust the values in `fnox.toml` if your item or field names differ (supported
formats: `Item`, `Item/field`, `op://Vault/Item/field`).

Fnox only injects the `default` mise environment, selected by `.miserc.toml`.
Override it with `MISE_ENV=ci` in CI, which receives its environment from
GitHub Actions secrets instead.

An `age` provider is also configured for secrets that should live encrypted
in git (`fnox set KEY value --provider age`); its private key is at
`~/.config/fnox/age.txt` — back it up somewhere safe.

## Setup

```sh
mise install                       # installs OpenTofu + fnox
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: set github_owner (and optionally ssh_keys)
# make sure `op` is signed in and the references in fnox.toml point at your
# 1Password items
mise run init
mise run plan
```

## Usage

- Add a repository: add an entry to `local.repositories` in `repositories.tf`,
  then `mise run apply`.
- Update your profile README: edit `profile/README.md`, then `mise run apply`.
- Add/revoke SSH keys: edit the `ssh_keys` map in `terraform.tfvars`,
  then `mise run apply`.

## Adopting existing repositories

Existing repos must be imported before Tofu can manage them:

```sh
fnox exec -- tofu import 'github_repository.this["my-project"]' my-project
fnox exec -- tofu import github_repository.profile <your-username>
```

Note: repositories have `lifecycle { prevent_destroy = true }`, so they cannot
be deleted accidentally via `tofu destroy`.

## CI

`.github/workflows/tofu.yml` runs `fnox check` → `init` → `validate` → `plan`
on pull requests, and `apply` on pushes to `main`. It uses
`jdx/mise-action` (installs opentofu + fnox from `mise.toml`) and
`1password/install-cli-action` (fnox's 1Password provider shells out to `op`).

Required GitHub secret: `OP_SERVICE_ACCOUNT_TOKEN` — a 1Password service
account token granted access to only the vault holding the GitHub token
(Settings → Integrations → Service Accounts; keep it read-only). Consider
storing it as an *environment* secret with branch protection so PR workflows
from forks can't reach it.

State is stored in the `hydra-tf-state-c1518487dba2` Backblaze B2 bucket via
its S3-compatible API. B2 credentials and endpoint settings are injected by
fnox from 1Password for both local commands and CI.
