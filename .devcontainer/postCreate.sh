#!/usr/bin/env bash
set -euo pipefail

echo "Configuring git credential helper (store)"

# Configure Azure DevOps credentials if provided
if [ -n "${AZURE_DEVOPS_USER:-}" ] && [ -n "${AZURE_DEVOPS_PAT:-}" ]; then
  echo "Configuring Azure DevOps credentials (primary)..."
  printf 'https://%s:%s@dev.azure.com\n' "$AZURE_DEVOPS_USER" "$AZURE_DEVOPS_PAT" >> "$HOME/.git-credentials"
  chmod 600 "$HOME/.git-credentials" || true
fi

git config --global credential.helper store
git config --global credential.useHttpPath true
git config --global user.name  "${GIT_USER_NAME:-}"
git config --global user.email  "${GIT_USER_EMAIL:-}"

# Install Azure CLI (optional)
if [ "${INSTALL_AZURE_CLI:-false}" = "true" ]; then
  echo "Installing Azure CLI..."
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash || echo "Azure CLI installation failed (non-blocking)"
else
  echo "Skipping Azure CLI (set INSTALL_AZURE_CLI=true to enable)"
fi

echo "postCreate done"