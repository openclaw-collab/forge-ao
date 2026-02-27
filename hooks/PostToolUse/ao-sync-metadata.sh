#!/bin/bash
# PostToolUse Hook: AO Metadata Sync
# Syncs FORGE workflow state to Agent Orchestrator metadata
#
# This hook only runs when AO_SESSION and AO_DATA_DIR are set,
# indicating we're running inside an AO-managed session.

set -e

# Source workspace root helper
source "$(dirname "$0")/../_lib/workspace-root.sh"

# Get workspace root
WORKSPACE_ROOT="$(get_workspace_root)"
FORGE_DIR="${WORKSPACE_ROOT}/.claude/forge"

# Check if we're in an AO session
if [ -z "$AO_SESSION" ] || [ -z "$AO_DATA_DIR" ]; then
    # Not in AO mode, skip silently
    exit 0
fi

# Check if metadata file exists
METADATA_FILE="${AO_DATA_DIR}/${AO_SESSION}"
if [ ! -f "$METADATA_FILE" ]; then
    # Metadata file doesn't exist yet, skip
    exit 0
fi

# Check if FORGE state exists
if [ ! -f "${FORGE_DIR}/active-workflow.md" ]; then
    # No active workflow, skip
    exit 0
fi

# Extract values from active-workflow.md (YAML frontmatter format)
FORGE_WORKFLOW_FILE="${FORGE_DIR}/active-workflow.md"

# Function to extract YAML frontmatter value
extract_yaml_value() {
    local key="$1"
    local file="$2"
    # Extract value from "key: value" format, handling quotes
    grep "^${key}:" "$file" 2>/dev/null | head -1 | sed -E 's/^[^:]+:[[:space:]]*["]?([^"]*)["]?$/\1/' | tr -d '\n'
}

# Read FORGE state
FORGE_PHASE=$(extract_yaml_value "phase" "$FORGE_WORKFLOW_FILE")
FORGE_STATUS=$(extract_yaml_value "status" "$FORGE_WORKFLOW_FILE")
FORGE_OBJECTIVE=$(extract_yaml_value "objective" "$FORGE_WORKFLOW_FILE")
FORGE_NEXT=$(extract_yaml_value "next_phase" "$FORGE_WORKFLOW_FILE")
FORGE_DEBATE_ID=$(extract_yaml_value "debate_id" "$FORGE_WORKFLOW_FILE")

# Also read completed_phases for summary
FORGE_COMPLETED=$(extract_yaml_value "completed_phases" "$FORGE_WORKFLOW_FILE")

# Read additional metadata fields
FORGE_BRANCH=$(extract_yaml_value "branch" "$FORGE_WORKFLOW_FILE")
FORGE_ISSUE=$(extract_yaml_value "issue" "$FORGE_WORKFLOW_FILE")
FORGE_VERSION=$(extract_yaml_value "version" "$FORGE_WORKFLOW_FILE")
FORGE_STARTED_AT=$(extract_yaml_value "started_at" "$FORGE_WORKFLOW_FILE")

# Check for debate gate status
FORGE_DEBATE_PENDING="false"
if [ -n "$FORGE_DEBATE_ID" ]; then
    DEBATE_DIR="${FORGE_DIR}/debate/${FORGE_DEBATE_ID}"
    if [ -d "$DEBATE_DIR" ]; then
        # Check if synthesis exists (gate passed)
        if [ ! -f "${DEBATE_DIR}/synthesis.md" ]; then
            FORGE_DEBATE_PENDING="true"
            FORGE_DEBATE_STATUS="pending"
        else
            FORGE_DEBATE_STATUS="complete"
        fi
    else
        FORGE_DEBATE_PENDING="true"
        FORGE_DEBATE_STATUS="initialized"
    fi
fi

# Build summary from body (everything after ---)
FORGE_SUMMARY=""
if [ -n "$FORGE_PHASE" ]; then
    # Extract body (after second ---)
    FORGE_SUMMARY=$(sed -n '/^---$/,/^---$/p' "$FORGE_WORKFLOW_FILE" | tail -n +2 | grep -v "^---$" | head -5 | tr '\n' ' ' | sed 's/[[:space:]]*$//')
fi

# Function to update a key in metadata file without overwriting unrelated keys
update_metadata_key() {
    local key="$1"
    local value="$2"
    local file="$3"

    if [ -z "$value" ]; then
        # Skip empty values
        return 0
    fi

    # Escape special characters for sed
    local escaped_value
    escaped_value=$(echo "$value" | sed 's/[&/\]/\\&/g')

    # Create temp file
    local temp_file="${file}.tmp.$$"

    if grep -q "^${key}=" "$file" 2>/dev/null; then
        # Key exists, update it
        sed "s/^${key}=.*/${key}=${escaped_value}/" "$file" > "$temp_file"
    else
        # Key doesn't exist, append it
        cp "$file" "$temp_file"
        echo "${key}=${escaped_value}" >> "$temp_file"
    fi

    # Atomic move
    mv "$temp_file" "$file"
}

# Update FORGE metadata keys in AO metadata file
# IMPORTANT: Only write forge_* keys, never overwrite AO's status lifecycle keys

if [ -n "$FORGE_PHASE" ]; then
    update_metadata_key "forge_phase" "$FORGE_PHASE" "$METADATA_FILE"
fi

if [ -n "$FORGE_STATUS" ]; then
    update_metadata_key "forge_status" "$FORGE_STATUS" "$METADATA_FILE"
fi

if [ -n "$FORGE_OBJECTIVE" ]; then
    # Truncate objective if too long for metadata
    if [ ${#FORGE_OBJECTIVE} -gt 200 ]; then
        FORGE_OBJECTIVE="${FORGE_OBJECTIVE:0:197}..."
    fi
    update_metadata_key "forge_objective" "$FORGE_OBJECTIVE" "$METADATA_FILE"
fi

if [ -n "$FORGE_NEXT" ]; then
    update_metadata_key "forge_next" "$FORGE_NEXT" "$METADATA_FILE"
fi

if [ -n "$FORGE_COMPLETED" ]; then
    update_metadata_key "forge_completed_phases" "$FORGE_COMPLETED" "$METADATA_FILE"
fi

if [ -n "$FORGE_SUMMARY" ]; then
    # Truncate summary if too long
    if [ ${#FORGE_SUMMARY} -gt 300 ]; then
        FORGE_SUMMARY="${FORGE_SUMMARY:0:297}..."
    fi
    update_metadata_key "forge_summary" "$FORGE_SUMMARY" "$METADATA_FILE"
fi

# Update additional metadata keys
if [ -n "$FORGE_BRANCH" ]; then
    update_metadata_key "forge_branch" "$FORGE_BRANCH" "$METADATA_FILE"
fi

if [ -n "$FORGE_ISSUE" ]; then
    update_metadata_key "forge_issue" "$FORGE_ISSUE" "$METADATA_FILE"
fi

if [ -n "$FORGE_VERSION" ]; then
    update_metadata_key "forge_version" "$FORGE_VERSION" "$METADATA_FILE"
fi

if [ -n "$FORGE_STARTED_AT" ]; then
    update_metadata_key "forge_started_at" "$FORGE_STARTED_AT" "$METADATA_FILE"
fi

# Update debate metadata if applicable
if [ -n "$FORGE_DEBATE_ID" ]; then
    update_metadata_key "forge_debate_id" "$FORGE_DEBATE_ID" "$METADATA_FILE"
    update_metadata_key "forge_debate_status" "$FORGE_DEBATE_STATUS" "$METADATA_FILE"
    update_metadata_key "forge_debate_pending" "$FORGE_DEBATE_PENDING" "$METADATA_FILE"
fi

# Also update a timestamp
DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
update_metadata_key "forge_last_updated" "$DATE" "$METADATA_FILE"

exit 0
