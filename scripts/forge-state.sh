#!/bin/bash
# FORGE State Manager
# Manages the .claude/forge/active-workflow.md state file
#
# Usage:
#   forge-state.sh init --objective "Implement X" --issue "123" --branch "feature/x"
#   forge-state.sh set-phase brainstorm
#   forge-state.sh complete-phase
#   forge-state.sh set-next research
#   forge-state.sh get-phase
#   forge-state.sh show

set -e

# Configuration
FORGE_VERSION="0.4.0"
STATE_FILENAME="active-workflow.md"

# Get workspace root
get_workspace_root() {
    if command -v git &> /dev/null; then
        local git_root
        git_root=$(git rev-parse --show-toplevel 2>/dev/null) || true
        if [ -n "$git_root" ]; then
            echo "$git_root"
            return 0
        fi
    fi

    if [ -n "$CLAUDE_PROJECT_DIR" ]; then
        echo "$CLAUDE_PROJECT_DIR"
        return 0
    fi

    pwd
}

WORKSPACE_ROOT="$(get_workspace_root)"
FORGE_DIR="${WORKSPACE_ROOT}/.claude/forge"
STATE_FILE="${FORGE_DIR}/${STATE_FILENAME}"

# Ensure FORGE directory exists
ensure_forge_dir() {
    if [ ! -d "$FORGE_DIR" ]; then
        mkdir -p "$FORGE_DIR"
    fi
}

# Get current ISO timestamp
timestamp() {
    date -u +"%Y-%m-%dT%H:%M:%SZ"
}

# Initialize new workflow state
cmd_init() {
    local objective=""
    local issue=""
    local branch=""
    local phase="initialize"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --objective)
                objective="$2"
                shift 2
                ;;
            --issue)
                issue="$2"
                shift 2
                ;;
            --branch)
                branch="$2"
                shift 2
                ;;
            --phase)
                phase="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done

    # Default objective if not provided
    if [ -z "$objective" ]; then
        objective="FORGE Workflow"
    fi

    # Use current branch if not provided
    if [ -z "$branch" ] && command -v git &> /dev/null; then
        branch=$(git branch --show-current 2>/dev/null || echo "")
    fi

    ensure_forge_dir

    local started_at
    started_at=$(timestamp)

    cat > "$STATE_FILE" << EOF
---
workflow: forge
version: "${FORGE_VERSION}"
objective: "${objective}"
phase: ${phase}
status: in_progress
started_at: ${started_at}
last_updated: ${started_at}
completed_phases: []
next_phase: null
branch: "${branch}"
issue: "${issue}"
---

# FORGE Workflow State

Objective: ${objective}

## Current Phase: ${phase}

Status: in_progress

## Summary

Workflow initialized at ${started_at}.

## Next Steps

- Complete ${phase} phase
- Write artifact to docs/forge/${phase}.md
EOF

    echo "✅ Initialized FORGE workflow: ${objective}"
}

# Set the current phase
cmd_set_phase() {
    local new_phase="$1"

    if [ -z "$new_phase" ]; then
        echo "Error: Phase name required" >&2
        exit 1
    fi

    if [ ! -f "$STATE_FILE" ]; then
        # Auto-initialize if not exists
        cmd_init --phase "$new_phase"
        return 0
    fi

    local now
    now=$(timestamp)

    # Update phase and timestamp using sed
    sed -i.bak "s/^phase: .*/phase: ${new_phase}/" "$STATE_FILE"
    sed -i.bak "s/^status: .*/status: in_progress/" "$STATE_FILE"
    sed -i.bak "s/^last_updated: .*/last_updated: ${now}/" "$STATE_FILE"
    rm -f "${STATE_FILE}.bak"

    # Update body section
    sed -i.bak "s/^## Current Phase: .*/## Current Phase: ${new_phase}/" "$STATE_FILE"
    sed -i.bak "s/^Status: .*/Status: in_progress/" "$STATE_FILE"
    rm -f "${STATE_FILE}.bak"

    echo "✅ Set phase to: ${new_phase}"
}

# Mark current phase as complete
cmd_complete_phase() {
    if [ ! -f "$STATE_FILE" ]; then
        echo "Error: No active workflow found" >&2
        exit 1
    fi

    local now
    now=$(timestamp)

    # Get current phase
    local current_phase
    current_phase=$(grep "^phase:" "$STATE_FILE" | head -1 | cut -d':' -f2 | tr -d ' "')

    if [ -z "$current_phase" ]; then
        echo "Error: Could not determine current phase" >&2
        exit 1
    fi

    # Update status and timestamp
    sed -i.bak "s/^status: .*/status: completed/" "$STATE_FILE"
    sed -i.bak "s/^last_updated: .*/last_updated: ${now}/" "$STATE_FILE"

    # Add to completed phases (simple approach - append to array notation)
    local current_completed
    current_completed=$(grep "^completed_phases:" "$STATE_FILE" | head -1)

    if [[ "$current_completed" == *"[]"* ]]; then
        # Empty array, replace with single element
        sed -i.bak "s/completed_phases: \[\]/completed_phases: [${current_phase}]/" "$STATE_FILE"
    elif [[ "$current_completed" == *"[${current_phase}]"* ]] || [[ "$current_completed" == *"${current_phase}]"* ]]; then
        # Already in array, do nothing
        true
    else
        # Add to array
        sed -i.bak "s/completed_phases: \[/completed_phases: [${current_phase}, /" "$STATE_FILE"
    fi

    rm -f "${STATE_FILE}.bak"

    echo "✅ Completed phase: ${current_phase}"
}

# Set the next phase
cmd_set_next() {
    local next_phase="$1"

    if [ -z "$next_phase" ]; then
        echo "Error: Next phase name required" >&2
        exit 1
    fi

    if [ ! -f "$STATE_FILE" ]; then
        echo "Error: No active workflow found" >&2
        exit 1
    fi

    local now
    now=$(timestamp)

    # Update next_phase and timestamp
    sed -i.bak "s/^next_phase: .*/next_phase: ${next_phase}/" "$STATE_FILE"
    sed -i.bak "s/^last_updated: .*/last_updated: ${now}/" "$STATE_FILE"
    rm -f "${STATE_FILE}.bak"

    echo "✅ Set next phase to: ${next_phase}"
}

# Get the current phase
cmd_get_phase() {
    if [ ! -f "$STATE_FILE" ]; then
        echo "none"
        return 0
    fi

    grep "^phase:" "$STATE_FILE" | head -1 | cut -d':' -f2 | tr -d ' "' || echo "none"
}

# Get the current status
cmd_get_status() {
    if [ ! -f "$STATE_FILE" ]; then
        echo "none"
        return 0
    fi

    grep "^status:" "$STATE_FILE" | head -1 | cut -d':' -f2 | tr -d ' "' || echo "none"
}

# Show full state
cmd_show() {
    if [ ! -f "$STATE_FILE" ]; then
        echo "No active workflow found."
        echo "Run: forge-state.sh init --objective \"Your objective\""
        exit 1
    fi

    echo "📋 FORGE Workflow State"
    echo "======================"
    echo ""
    cat "$STATE_FILE"
}

# Pause workflow
cmd_pause() {
    if [ ! -f "$STATE_FILE" ]; then
        echo "Error: No active workflow found" >&2
        exit 1
    fi

    local now
    now=$(timestamp)

    sed -i.bak "s/^status: .*/status: paused/" "$STATE_FILE"
    sed -i.bak "s/^last_updated: .*/last_updated: ${now}/" "$STATE_FILE"
    rm -f "${STATE_FILE}.bak"

    echo "⏸️  Workflow paused"
}

# Resume workflow
cmd_resume() {
    if [ ! -f "$STATE_FILE" ]; then
        echo "Error: No active workflow found" >&2
        exit 1
    fi

    local now
    now=$(timestamp)

    sed -i.bak "s/^status: .*/status: in_progress/" "$STATE_FILE"
    sed -i.bak "s/^last_updated: .*/last_updated: ${now}/" "$STATE_FILE"
    rm -f "${STATE_FILE}.bak"

    echo "▶️  Workflow resumed"
}

# Archive completed workflow
cmd_archive() {
    if [ ! -f "$STATE_FILE" ]; then
        echo "Error: No active workflow found" >&2
        exit 1
    fi

    local archive_dir="${FORGE_DIR}/archive"
    mkdir -p "$archive_dir"

    local timestamp
    timestamp=$(date -u +"%Y%m%d_%H%M%S")

    local objective
    objective=$(grep "^objective:" "$STATE_FILE" | head -1 | cut -d':' -f2 | tr -d ' "' | tr ' ' '_' | tr '/' '_')

    local archive_name="workflow_${timestamp}_${objective}.md"

    # Mark as completed
    local now
    now=$(timestamp)
    sed -i.bak "s/^status: .*/status: completed/" "$STATE_FILE"
    sed -i.bak "s/^last_updated: .*/last_updated: ${now}/" "$STATE_FILE"
    rm -f "${STATE_FILE}.bak"

    # Copy to archive
    cp "$STATE_FILE" "${archive_dir}/${archive_name}"

    # Clear active workflow
    rm "$STATE_FILE"

    echo "✅ Workflow archived to: ${archive_dir}/${archive_name}"
}

# Main command dispatcher
case "${1:-}" in
    init)
        shift
        cmd_init "$@"
        ;;
    set-phase)
        cmd_set_phase "$2"
        ;;
    complete-phase|complete)
        cmd_complete_phase
        ;;
    set-next)
        cmd_set_next "$2"
        ;;
    get-phase)
        cmd_get_phase
        ;;
    get-status)
        cmd_get_status
        ;;
    show|status)
        cmd_show
        ;;
    pause)
        cmd_pause
        ;;
    resume)
        cmd_resume
        ;;
    archive)
        cmd_archive
        ;;
    help|--help|-h)
        echo "FORGE State Manager"
        echo ""
        echo "Usage: forge-state.sh <command> [options]"
        echo ""
        echo "Commands:"
        echo "  init --objective \"...\" [--issue N] [--branch B] [--phase P]"
        echo "                    Initialize new workflow"
        echo "  set-phase <phase>  Set current phase"
        echo "  complete-phase    Mark current phase complete"
        echo "  set-next <phase>  Set next phase recommendation"
        echo "  get-phase         Show current phase"
        echo "  get-status        Show current status"
        echo "  show              Show full workflow state"
        echo "  pause             Pause workflow"
        echo "  resume            Resume workflow"
        echo "  archive           Archive and clear workflow"
        echo ""
        ;;
    *)
        echo "Error: Unknown command: ${1:-}" >&2
        echo "Run 'forge-state.sh help' for usage" >&2
        exit 1
        ;;
esac

exit 0
