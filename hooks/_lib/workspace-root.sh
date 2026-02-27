#!/bin/bash
# Workspace Root Helper for FORGE Hooks
#
# This script provides a get_workspace_root() function that correctly
# identifies the workspace root (git repo) rather than the plugin directory.
#
# Usage:
#   source "$(dirname "$0")/../_lib/workspace-root.sh"
#   WORKSPACE_ROOT="$(get_workspace_root)"
#   cd "$WORKSPACE_ROOT"

# Get the workspace root using the following priority:
# 1. Git repository top-level (if in a git repo)
# 2. CLAUDE_PROJECT_DIR environment variable (if set)
# 3. Current working directory (fallback)
get_workspace_root() {
    # Try git first (most reliable for AO workspaces)
    if command -v git &> /dev/null; then
        local git_root
        git_root=$(git rev-parse --show-toplevel 2>/dev/null) || true
        if [ -n "$git_root" ]; then
            echo "$git_root"
            return 0
        fi
    fi

    # Fall back to CLAUDE_PROJECT_DIR
    if [ -n "$CLAUDE_PROJECT_DIR" ]; then
        echo "$CLAUDE_PROJECT_DIR"
        return 0
    fi

    # Final fallback: current directory
    pwd
}

# Get the FORGE state directory (workspace-local in AO mode)
get_forge_dir() {
    local workspace
    workspace="$(get_workspace_root)"
    echo "${workspace}/.claude/forge"
}

# Get the FORGE memory directory (workspace-local in AO mode)
get_memory_dir() {
    local forge_dir
    forge_dir="$(get_forge_dir)"
    echo "${forge_dir}/memory"
}

# Export functions for use in other scripts
export -f get_workspace_root
export -f get_forge_dir
export -f get_memory_dir
