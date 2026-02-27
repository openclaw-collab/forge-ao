#!/bin/bash
# PostToolUse Hook: Lint Check
# Runs linter on modified source files
# Simplified to 3 primary gates: ESLint, TypeScript, Prettier

set -e

# Source workspace root helper
source "$(dirname "$0")/../_lib/workspace-root.sh"

# Get workspace root (not plugin root)
WORKSPACE_ROOT="$(get_workspace_root)"
FILE="$1"

# Only check source files
if [[ "$FILE" =~ \.(js|jsx|ts|tsx)$ ]]; then
  cd "$WORKSPACE_ROOT" || exit 0

  # Gate 1: ESLint (JavaScript/TypeScript)
  if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f ".eslintrc.yml" ] || [ -f ".eslintrc" ] || [ -f "eslint.config.js" ]; then
    if command -v npx &> /dev/null; then
      echo "🔍 ESLint: $FILE"
      npx eslint "$FILE" --fix --quiet 2>/dev/null || true
    fi
  fi

  # Gate 2: Prettier (Formatting)
  if [ -f ".prettierrc" ] || [ -f ".prettierrc.json" ] || [ -f ".prettierrc.js" ] || [ -f "prettier.config.js" ]; then
    if command -v npx &> /dev/null; then
      echo "✨ Prettier: $FILE"
      npx prettier --write "$FILE" --log-level=error 2>/dev/null || true
    fi
  fi
fi

# Gate 3: Python (Black)
if [[ "$FILE" =~ \.py$ ]]; then
  if command -v black &> /dev/null; then
    echo "🐍 Black: $FILE"
    black --quiet "$FILE" 2>/dev/null || true
  fi
fi

exit 0
