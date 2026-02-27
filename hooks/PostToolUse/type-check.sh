#!/bin/bash
# PostToolUse Hook: Type Check on Save
# Runs TypeScript type checking after .ts/.tsx edits
# Personalize: Adjust timeout or add other type checkers

set -e

# Source workspace root helper
source "$(dirname "$0")/../_lib/workspace-root.sh"

# Get workspace root (not plugin root)
WORKSPACE_ROOT="$(get_workspace_root)"

FILE="$1"

# Only run on TypeScript files
if [[ "$FILE" =~ \.(ts|tsx)$ ]]; then
  # Change to workspace root for proper tsconfig resolution
  cd "$WORKSPACE_ROOT" || exit 0

  # Check if tsconfig.json exists
  if [ -f "tsconfig.json" ]; then
    # Run type check (with timeout to prevent hanging)
    timeout 30s npx tsc --noEmit 2>/dev/null || true
  fi
fi

exit 0
