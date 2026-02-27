#!/bin/bash
# FORGE Artifact Manager
# Handles artifact creation and cleanup based on artifact level

set -e

COMMAND=$1
LEVEL=$2

# Default to intelligent level if not specified
if [ -z "$LEVEL" ]; then
  LEVEL="intelligent"
fi

echo "📁 FORGE Artifact Manager"
echo "Level: $LEVEL"
echo "Command: $COMMAND"
echo "========================"

case $COMMAND in
  "init")
    echo "Initializing artifact directories..."
    mkdir -p docs/forge
    mkdir -p .claude/memory/forge/{brainstorm,debate,completed,reviews}
    echo "✅ Directories created"
    ;;

  "cleanup")
    echo "Cleaning up temporary artifacts..."

    # Always clean temp files
    rm -rf .claude/memory/forge/brainstorm/*.md 2>/dev/null || true
    rm -rf .claude/memory/forge/debate/*.md 2>/dev/null || true
    rm -rf .claude/memory/forge/completed/*.md 2>/dev/null || true
    rm -rf .claude/memory/forge/reviews/*.md 2>/dev/null || true
    rm -f .claude/memory/forge/test-*.md 2>/dev/null || true
    rm -f .claude/memory/forge/decision.md 2>/dev/null || true

    case $LEVEL in
      "minimal")
        # Keep only plan and learn artifacts
        rm -f docs/forge/brainstorm.md 2>/dev/null || true
        rm -f docs/forge/research.md 2>/dev/null || true
        rm -f docs/forge/design.md 2>/dev/null || true
        rm -f docs/forge/test-results.md 2>/dev/null || true
        rm -f docs/forge/validation.md 2>/dev/null || true
        rm -f docs/forge/review.md 2>/dev/null || true
        echo "✅ Minimal cleanup complete (kept plan + learn)"
        ;;

      "intelligent")
        # Keep brainstorm, plan, test, review, learn
        rm -f docs/forge/research.md 2>/dev/null || true
        rm -f docs/forge/design.md 2>/dev/null || true
        rm -f docs/forge/validation.md 2>/dev/null || true
        echo "✅ Intelligent cleanup complete"
        ;;

      "maximal")
        # Keep all phase documents
        echo "✅ Maximal cleanup complete (kept all artifacts)"
        ;;
    esac
    ;;

  "list")
    echo "Current artifacts:"
    ls -la docs/forge/ 2>/dev/null || echo "  (no docs/forge directory)"
    ;;

  *)
    echo "Usage: $0 {init|cleanup|list} [minimal|intelligent|maximal]"
    exit 1
    ;;
esac
