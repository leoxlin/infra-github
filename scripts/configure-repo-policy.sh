#!/usr/bin/env bash
set -euo pipefail

# TODO: Migrate these policies to github_repository once the provider supports them.
repository_ids="$(tofu output -json github_repository_node_ids | jq -er '.[]')"

while IFS= read -r repository_id; do
  # shellcheck disable=SC2016 # GraphQL variables must reach gh unchanged.
  gh api graphql --silent \
    -f query='mutation($repositoryId: ID!) { updateRepository(input: { repositoryId: $repositoryId, issueCreationPolicy: COLLABORATORS_ONLY, pullRequestCreationPolicy: COLLABORATORS_ONLY }) { repository { id } } }' \
    -F repositoryId="$repository_id"
done <<<"$repository_ids"
