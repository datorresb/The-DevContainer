#!/usr/bin/env bash
set -euo pipefail
#
# Fix known issues in compound-engineering plugin output for Copilot.
#
# Usage:
#   1. Install the plugin first:
#      bunx @every-env/compound-plugin install compound-engineering --to copilot
#
#   2. Then run this script:
#      bash .devcontainer/fix-compound-copilot.sh
#
# Fixes:
#   1. Remove `tools: ["*"]` (not valid for Copilot agents)
#   2. Replace `infer: true` with `user-invocable: true`
#   3. Replace `ce:` namespace references with `ce-` in body text
#

AGENTS_DIR="${1:-.github/agents}"

if [ ! -d "$AGENTS_DIR" ]; then
  echo "Error: agents directory '$AGENTS_DIR' not found."
  echo "Usage: bash .devcontainer/fix-compound-copilot.sh [agents-dir]"
  exit 1
fi

count=0
for file in "$AGENTS_DIR"/*.agent.md; do
  [ -f "$file" ] || continue

  # 1. Remove tools: ["*"] or tools:\n  - "*" block
  sed -i '/^tools:$/,/^[^ -]/{ /^tools:$/d; /^  - /d; }' "$file"
  sed -i "/^tools: \['\*'\]$/d" "$file"
  sed -i '/^tools: \["\*"\]$/d' "$file"

  # 2. Replace infer: true with user-invocable: true
  sed -i 's/^infer: true$/user-invocable: true/' "$file"

  # 3. Replace ce: namespace with ce- in body content (not in URLs or non-command contexts)
  # Only match ce: after start-of-line, whitespace, or common delimiters (not /)
  sed -i 's/\(^\|[[:space:],(.)"`'"'"']\)ce:\([a-z*][a-z0-9_*-]*\)/\1ce-\2/g' "$file"

  count=$((count + 1))
done

echo "Fixed $count agent files in $AGENTS_DIR"
