#!/bin/bash
# PreToolUse Hook: Confirm Destructive Operations
# Warns before potentially destructive file operations

set -e

# Source workspace root helper
source "$(dirname "$0")/../_lib/workspace-root.sh"

# Get workspace root
WORKSPACE_ROOT="$(get_workspace_root)"
cd "$WORKSPACE_ROOT"

# Get arguments from hook
FILE="$1"
OPERATION="$2"  # Write, Edit, etc.

# Skip if not a destructive operation
if [[ "$OPERATION" != "Write" && "$OPERATION" != "Edit" ]]; then
    exit 0
fi

# Check for git-related files
if [[ "$FILE" =~ \.git ]] || [[ "$FILE" =~ \.gitignore$ ]] || [[ "$FILE" =~ \.git/ ]]; then
    echo "⚠️  WARNING: You are about to modify a git-related file: $FILE"
    echo "    This could affect version control functionality."
    echo ""
    read -p "Continue? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Operation cancelled by user"
        exit 1
    fi
fi

# Check for large files (>10KB)
if [ -f "$FILE" ]; then
    FILE_SIZE=$(stat -f%z "$FILE" 2>/dev/null || stat -c%s "$FILE" 2>/dev/null || echo "0")
    if [ "$FILE_SIZE" -gt 10240 ]; then
        echo "⚠️  WARNING: You are about to overwrite a large file: $FILE"
        echo "    Size: $FILE_SIZE bytes ($(($FILE_SIZE / 1024)) KB)"
        echo ""
        read -p "Continue? [y/N] " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "❌ Operation cancelled by user"
            exit 1
        fi
    fi
fi

# Check for critical configuration files
if [[ "$FILE" =~ ^\.claude/settings\.json$ ]] || [[ "$FILE" =~ ^\.claude/CLAUDE\.md$ ]]; then
    echo "⚠️  WARNING: You are about to modify a critical configuration file: $FILE"
    echo "    This could affect Claude Code behavior."
    echo ""
    read -p "Continue? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Operation cancelled by user"
        exit 1
    fi
fi

exit 0
