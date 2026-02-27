#!/bin/bash
# PostToolUse Hook: Format on Save
# Auto-formats code after Edit/Write operations
# Personalize: Adjust for your project's formatter (prettier, black, gofmt, etc.)

set -e

# Source workspace root helper
source "$(dirname "$0")/../_lib/workspace-root.sh"

# Get workspace root (works in AO mode)
WORKSPACE_ROOT="$(get_workspace_root)"
cd "$WORKSPACE_ROOT"

# Detect file type and format accordingly
FILE="$1"

if [[ "$FILE" =~ \.(ts|tsx|js|jsx|json|md|css|scss)$ ]]; then
  # JavaScript/TypeScript projects
  if command -v prettier &> /dev/null; then
    prettier --write "$FILE" 2>/dev/null || true
  fi
fi

if [[ "$FILE" =~ \.py$ ]]; then
  # Python projects
  if command -v black &> /dev/null; then
    black "$FILE" 2>/dev/null || true
  fi
fi

if [[ "$FILE" =~ \.go$ ]]; then
  # Go projects
  if command -v gofmt &> /dev/null; then
    gofmt -w "$FILE" 2>/dev/null || true
  fi
fi

if [[ "$FILE" =~ \.rs$ ]]; then
  # Rust projects
  if command -v rustfmt &> /dev/null; then
    rustfmt "$FILE" 2>/dev/null || true
  fi
fi

# Log formatting (optional)
# echo "[$(date '+%Y-%m-%d %H:%M:%S')] Formatted: $FILE" >> .claude/logs/format.log
