#!/bin/bash
# SessionStart Hook: FORGE Initialization
# Detects workspace state and initializes FORGE workflow
# Personalize: Adjust detection logic for your project structure

set -e

# Source workspace root helper
source "$(dirname "$0")/../_lib/workspace-root.sh"

# Get workspace root (not plugin root - this is the key fix for AO mode)
WORKSPACE_ROOT="$(get_workspace_root)"
FORGE_DIR="${WORKSPACE_ROOT}/.claude/forge"
MEMORY_DIR="$(get_memory_dir)"

# =============================================================================
# AO FORGE Context Detection
# =============================================================================

# Check if we're running in an AO-spawned FORGE session
IS_AO_FORGE_SESSION=false
if [ -n "$AO_FORGE_DEBATE_ID" ]; then
  IS_AO_FORGE_SESSION=true
fi

# If this is an AO FORGE session, load the system prompt
if [ "$IS_AO_FORGE_SESSION" = true ]; then
  echo "🔥 FORGE-AO Session Detected"
  echo "============================"
  echo ""
  echo "Debate ID: ${AO_FORGE_DEBATE_ID}"
  echo "Role: ${AO_FORGE_ROLE}"
  echo "Phase: ${AO_FORGE_PHASE}"
  echo "Project: ${AO_FORGE_PROJECT_ID}"
  echo ""

  # Load FORGE system prompt if available
  FORGE_SYSTEM_PROMPT="${WORKSPACE_ROOT}/.claude/forge/system-prompt.md"
  if [ -f "$FORGE_SYSTEM_PROMPT" ]; then
    echo "📋 Loading FORGE system prompt..."
    # The system prompt will be loaded by Claude Code via --append-system-prompt
    # This marker file indicates the session should use FORGE mode
    touch "${FORGE_DIR}/.ao_forge_active"
  fi

  # Ensure FORGE directory structure exists
  if [ ! -d "${FORGE_DIR}/knowledge" ]; then
    echo "📁 Initializing FORGE workspace structure..."
    mkdir -p "${FORGE_DIR}/knowledge"
    mkdir -p "${FORGE_DIR}/snapshots"
    mkdir -p "${WORKSPACE_ROOT}/docs/forge/phases"
    mkdir -p "${WORKSPACE_ROOT}/docs/forge/handoffs"
    mkdir -p "${WORKSPACE_ROOT}/docs/forge/debate"
  fi

  echo ""
  echo "✅ FORGE-AO session ready"
  echo ""
  echo "Run /forge:continue to resume workflow"
  echo ""

  # Skip normal initialization for AO FORGE sessions
  exit 0
fi

# =============================================================================
# Normal FORGE Initialization (non-AO mode)
# =============================================================================

echo "🔥 FORGE Initialization"
echo "======================"
echo ""
echo "Workspace: ${WORKSPACE_ROOT}"
echo ""

# Check if this is a new FORGE workspace
if [ ! -d "${FORGE_DIR}" ]; then
  echo ""
  echo "Welcome to FORGE!"
  echo ""
  echo "This appears to be a new workspace. FORGE can help you:"
  echo "  • Plan and build features systematically"
  echo "  • Ensure code quality with reviews"
  echo "  • Capture learnings for future work"
  echo ""

  # Detect project type (run from workspace root)
  cd "$WORKSPACE_ROOT"
  if [ -f "package.json" ]; then
    PROJECT_TYPE="JavaScript/Node.js"
  elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    PROJECT_TYPE="Python"
  elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="Rust"
  elif [ -f "go.mod" ]; then
    PROJECT_TYPE="Go"
  else
    PROJECT_TYPE="Unknown"
  fi

  echo "Detected project type: $PROJECT_TYPE"
  echo ""
  echo "To start FORGE, run: /forge:start"
  echo ""
fi

# Check for pending insights marker
if [ -f "${MEMORY_DIR}/.insights_pending/active" ]; then
  echo ""
  echo "📊 Pending Insights Available"
  echo "Run /forge:learn to process captured knowledge from previous session"
  echo ""
fi

# Check for in-progress FORGE workflow (new active-workflow.md format)
if [ -f "${FORGE_DIR}/active-workflow.md" ]; then
  CURRENT_PHASE=$(grep "^phase:" "${FORGE_DIR}/active-workflow.md" | head -1 | cut -d':' -f2 | tr -d ' "')
  CURRENT_STATUS=$(grep "^status:" "${FORGE_DIR}/active-workflow.md" | head -1 | cut -d':' -f2 | tr -d ' "')

  if [ -n "$CURRENT_PHASE" ] && [ "$CURRENT_STATUS" = "in_progress" ]; then
    echo ""
    echo "📋 Resuming FORGE Workflow"
    echo "Current phase: $CURRENT_PHASE"
    echo ""
    echo "To continue, run: /forge:continue"
    echo ""
  fi
# Legacy: Check for old state.json format
elif [ -f "${FORGE_DIR}/state.json" ]; then
  CURRENT_PHASE=$(cat "${FORGE_DIR}/state.json" 2>/dev/null | grep -o '"current_phase":"[^"]*"' | cut -d'"' -f4)

  if [ -n "$CURRENT_PHASE" ]; then
    echo ""
    echo "📋 Resuming FORGE Workflow"
    echo "Current phase: $CURRENT_PHASE"
    echo ""
    echo "To continue, run: /forge:start"
    echo ""
  fi
fi

# Create memory directories if they don't exist
mkdir -p "${MEMORY_DIR}/entities"
mkdir -p "${MEMORY_DIR}/patterns"
mkdir -p "${MEMORY_DIR}/learnings"
mkdir -p "${MEMORY_DIR}/session-snapshots"

# Create docs/forge directory for artifacts
mkdir -p "${WORKSPACE_ROOT}/docs/forge"

echo ""
echo "✅ FORGE ready"
echo ""

exit 0
