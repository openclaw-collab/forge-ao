#!/bin/bash
# PreToolUse Hook: Block Lockfile Edits
# Warns about changes to lock files that could cause issues
# Personalize: Adjust for your package manager (npm, yarn, pnpm, poetry, etc.)

set -e

# Source workspace root helper
source "$(dirname "$0")/../_lib/workspace-root.sh"

FILE="$1"

# Lock files to protect
LOCK_FILES=(
  "package-lock.json"
  "yarn.lock"
  "pnpm-lock.yaml"
  "Cargo.lock"
  "Gemfile.lock"
  "poetry.lock"
  "composer.lock"
  "mix.lock"
  "go.sum"
  "bun.lockb"
  "deno.lock"
)

BASENAME=$(basename "$FILE")

for lockfile in "${LOCK_FILES[@]}"; do
  if [[ "$BASENAME" == "$lockfile" ]]; then
    echo ""
    echo "⚠️  WARNING: Editing $lockfile"
    echo ""
    echo "Lock files are auto-generated and should not be manually edited."
    echo "Changes may cause dependency inconsistencies."
    echo ""
    echo "Recommended approach:"
    echo "  1. Edit package.json (or equivalent) instead"
    echo "  2. Run package manager install/update command"
    echo "  3. Let the lock file update automatically"
    echo ""
    echo "If you must edit manually, ensure you understand the implications."
    echo ""
    # Don't block, just warn
    exit 0
  fi
done

exit 0
