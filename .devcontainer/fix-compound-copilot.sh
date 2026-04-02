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
#   3. Replace `ce:` namespace references with `ce-` in all content
#

GITHUB_DIR="${1:-.github}"

if [ ! -d "$GITHUB_DIR" ]; then
  echo "Error: directory '$GITHUB_DIR' not found."
  echo "Usage: bash .devcontainer/fix-compound-copilot.sh [.github-dir]"
  exit 1
fi

fix_ce_colons() {
  # Replace ce: namespace with ce- (not in URLs or non-command contexts)
  # Handles multi-colon refs: ce:work:beta → ce-work-beta
  perl -i -pe 's/(?<=^|[\s,.()`'"'"'"])ce:([a-z*][a-z0-9_*:-]*)/"ce-" . ($1 =~ s{:}{-}gr)/geim' "$1"
}

# Fix agent files
agent_count=0
if [ -d "$GITHUB_DIR/agents" ]; then
  for file in "$GITHUB_DIR/agents"/*.agent.md; do
    [ -f "$file" ] || continue

    # 1. Remove tools: ["*"] or tools:\n  - "*" block
    sed -i '/^tools:$/,/^[^ -]/{ /^tools:$/d; /^  - /d; }' "$file"
    sed -i "/^tools: \['\*'\]$/d" "$file"
    sed -i '/^tools: \["\*"\]$/d' "$file"

    # 2. Replace infer: true with user-invocable: true
    sed -i 's/^infer: true$/user-invocable: true/' "$file"

    # 3. Replace ce: namespace references
    fix_ce_colons "$file"

    agent_count=$((agent_count + 1))
  done
fi

# Fix skill files
skill_count=0
if [ -d "$GITHUB_DIR/skills" ]; then
  while IFS= read -r -d '' file; do
    # Skills only need the ce: fix (no tools/infer in SKILL.md frontmatter)
    fix_ce_colons "$file"
    skill_count=$((skill_count + 1))
  done < <(find "$GITHUB_DIR/skills" -name "SKILL.md" -print0)
fi

echo "Fixed $agent_count agent files and $skill_count skill files in $GITHUB_DIR"
