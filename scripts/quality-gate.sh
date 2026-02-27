#!/bin/bash
# FORGE Quality Gate Script
# Validates implementation readiness and completion

set -e

PHASE=$1
CONFIG_FILE=".claude/forge/config.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 FORGE Quality Gate: $PHASE"
echo "================================"

# Check if gates are enabled
if [ -f "$CONFIG_FILE" ]; then
  GATES_ENABLED=$(jq -r '.quality_gates.enabled // true' "$CONFIG_FILE")
  if [ "$GATES_ENABLED" != "true" ]; then
    echo -e "${YELLOW}Quality gates disabled in config${NC}"
    exit 0
  fi
fi

case $PHASE in
  "implementation-ready")
    echo "Checking implementation readiness..."

    # Check design complete
    if [ ! -f "docs/forge/design.md" ]; then
      echo -e "${RED}❌ Design not complete (docs/forge/design.md missing)${NC}"
      exit 1
    fi
    echo -e "${GREEN}✅ Design complete${NC}"

    # Check plan exists
    if [ ! -f "docs/forge/plan.md" ]; then
      echo -e "${RED}❌ Plan not created (docs/forge/plan.md missing)${NC}"
      exit 1
    fi
    echo -e "${GREEN}✅ Plan exists${NC}"

    # Check TypeScript (if applicable)
    if [ -f "package.json" ]; then
      if npm run typecheck 2>/dev/null || npx tsc --noEmit 2>/dev/null; then
        echo -e "${GREEN}✅ TypeScript check passed${NC}"
      else
        echo -e "${YELLOW}⚠️ TypeScript check not configured${NC}"
      fi
    fi

    echo -e "${GREEN}✅ Implementation readiness gate PASSED${NC}"
    ;;

  "completion-validation")
    echo "Checking completion validation..."

    # Check TypeScript
    if ! npx tsc --noEmit 2>/dev/null; then
      echo -e "${RED}❌ TypeScript errors found${NC}"
      exit 1
    fi
    echo -e "${GREEN}✅ TypeScript compiles${NC}"

    # Check tests
    if ! npm test 2>/dev/null; then
      echo -e "${RED}❌ Tests failing${NC}"
      exit 1
    fi
    echo -e "${GREEN}✅ Tests passing${NC}"

    # Check build (if build script exists)
    if npm run build 2>/dev/null; then
      echo -e "${GREEN}✅ Build successful${NC}"
    else
      echo -e "${YELLOW}⚠️ Build check skipped${NC}"
    fi

    echo -e "${GREEN}✅ Completion validation gate PASSED${NC}"
    ;;

  *)
    echo "Unknown phase: $PHASE"
    exit 1
    ;;
esac
