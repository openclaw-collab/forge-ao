#!/bin/bash
# PreToolUse Hook: Block .env file edits
# Prevents accidental commits of sensitive files
# Personalize: Add other sensitive file patterns

set -e

# Source workspace root helper
source "$(dirname "$0")/../_lib/workspace-root.sh"

FILE="$1"
OPERATION="$2"

# Check if editing a sensitive file
if [[ "$FILE" =~ \.env || "$FILE" =~ \.env\. || "$FILE" =~ \.pem$ || "$FILE" =~ \.key$ ]]; then
  echo "⚠️  SECURITY WARNING: Attempting to edit sensitive file: $FILE"
  echo ""
  echo "This file may contain secrets, credentials, or sensitive configuration."
  echo ""
  echo "Options:"
  echo "  1. Cancel edit (recommended)"
  echo "  2. Continue with caution"
  echo ""
  read -p "Continue? (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

exit 0
