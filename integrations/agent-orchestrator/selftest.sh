#!/bin/bash
# FORGE Agent Orchestrator Integration Self-Test
#
# This script tests the FORGE AO integration by:
# 1. Creating a temporary git repository
# 2. Running the installer
# 3. Verifying all expected files exist

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test tracking
TESTS_PASSED=0
TESTS_FAILED=0

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORGE_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Create temp directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo "========================================"
echo "FORGE AO Integration Self-Test"
echo "========================================"
echo ""
echo "Temp directory: $TEMP_DIR"
echo "FORGE root: $FORGE_ROOT"
echo ""

# Helper functions
pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
    ((TESTS_PASSED++))
}

fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    ((TESTS_FAILED++))
}

info() {
    echo -e "${YELLOW}ℹ INFO${NC}: $1"
}

# Test 1: Create temp git repo
echo "Test 1: Creating temporary git repository..."
cd "$TEMP_DIR"
git init --quiet
pass "Created git repository"

# Test 2: Run installer
echo ""
echo "Test 2: Running installer..."
if node "${SCRIPT_DIR}/install.mjs" --workspace "$TEMP_DIR" --mode ao; then
    pass "Installer completed successfully"
else
    fail "Installer failed"
    exit 1
fi

# Test 3: Check .claude directory exists
echo ""
echo "Test 3: Checking .claude directory structure..."
if [ -d "$TEMP_DIR/.claude" ]; then
    pass ".claude directory exists"
else
    fail ".claude directory missing"
fi

# Test 4: Check forge directory exists
if [ -d "$TEMP_DIR/.claude/forge" ]; then
    pass ".claude/forge directory exists"
else
    fail ".claude/forge directory missing"
fi

# Test 5: Check hooks directory exists
if [ -d "$TEMP_DIR/.claude/forge/hooks" ]; then
    pass ".claude/forge/hooks directory exists"
else
    fail ".claude/forge/hooks directory missing"
fi

# Test 6: Check settings.json exists
echo ""
echo "Test 6: Checking settings.json..."
if [ -f "$TEMP_DIR/.claude/settings.json" ]; then
    pass "settings.json exists"
else
    fail "settings.json missing"
fi

# Test 7: Check settings.json contains FORGE hooks
if grep -q "forge-init.sh" "$TEMP_DIR/.claude/settings.json"; then
    pass "settings.json contains SessionStart hook"
else
    fail "settings.json missing SessionStart hook"
fi

if grep -q "ao-sync-metadata.sh" "$TEMP_DIR/.claude/settings.json"; then
    pass "settings.json contains AO sync hook"
else
    fail "settings.json missing AO sync hook"
fi

if grep -q "block-env-edits.sh" "$TEMP_DIR/.claude/settings.json"; then
    pass "settings.json contains safety hooks"
else
    fail "settings.json missing safety hooks"
fi

# Test 8: Check hooks are executable
echo ""
echo "Test 8: Checking hook executability..."
HOOK_COUNT=0
for hook in "$TEMP_DIR/.claude/forge/hooks"/*/*.sh; do
    if [ -x "$hook" ]; then
        ((HOOK_COUNT++))
    else
        fail "Hook not executable: $hook"
    fi
done
if [ $HOOK_COUNT -gt 0 ]; then
    pass "$HOOK_COUNT hooks are executable"
fi

# Test 9: Check forge-system-prompt.md exists
echo ""
echo "Test 9: Checking forge-system-prompt.md..."
if [ -f "$TEMP_DIR/.claude/forge/forge-system-prompt.md" ]; then
    pass "forge-system-prompt.md exists"
else
    fail "forge-system-prompt.md missing"
fi

# Test 10: Check active-workflow.md exists
echo ""
echo "Test 10: Checking active-workflow.md..."
if [ -f "$TEMP_DIR/.claude/forge/active-workflow.md" ]; then
    pass "active-workflow.md exists"
else
    fail "active-workflow.md missing"
fi

# Test 11: Check workspace-root.sh helper exists
echo ""
echo "Test 11: Checking workspace-root.sh helper..."
if [ -f "$TEMP_DIR/.claude/forge/hooks/_lib/workspace-root.sh" ]; then
    pass "workspace-root.sh exists"
else
    fail "workspace-root.sh missing"
fi

# Test 12: Test idempotency
echo ""
echo "Test 12: Testing idempotency (running installer again)..."
if node "${SCRIPT_DIR}/install.mjs" --workspace "$TEMP_DIR" --mode ao > /dev/null 2>&1; then
    # Count how many times forge-init.sh appears (should be 1)
    COUNT=$(grep -c "forge-init.sh" "$TEMP_DIR/.claude/settings.json" || echo "0")
    if [ "$COUNT" = "1" ]; then
        pass "Installer is idempotent (no duplicate entries)"
    else
        fail "Installer created duplicate entries (count: $COUNT)"
    fi
else
    fail "Second installer run failed"
fi

# Test 13: Check _lib directory exists
if [ -d "$TEMP_DIR/.claude/forge/hooks/_lib" ]; then
    pass "_lib directory exists"
else
    fail "_lib directory missing"
fi

# Summary
echo ""
echo "========================================"
echo "Test Summary"
echo "========================================"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ ALL TESTS PASSED${NC}"
    exit 0
else
    echo -e "${RED}✗ SOME TESTS FAILED${NC}"
    exit 1
fi
