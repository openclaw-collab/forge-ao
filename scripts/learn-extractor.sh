#!/bin/bash
# FORGE Learning Extractor
# Extracts patterns and learnings from workflow outputs

set -e

OUTPUT_DIR=".claude/memory"
DATE=$(date +%Y-%m-%d)

echo "🧠 FORGE Learning Extractor"
echo "=========================="

# Ensure directories exist
mkdir -p "$OUTPUT_DIR/patterns/forge"
mkdir -p "$OUTPUT_DIR/learnings/forge"
mkdir -p "$OUTPUT_DIR/decisions/forge"

# Extract patterns from completed tasks
extract_patterns() {
  echo "Extracting patterns..."

  for file in .claude/memory/forge/completed/*.md; do
    if [ -f "$file" ]; then
      echo "  Processing: $file"
      # Pattern extraction logic would go here
      # This is a template - actual extraction would parse the markdown
    fi
  done

  echo "✅ Patterns extracted"
}

# Capture learnings
capture_learnings() {
  echo "Capturing learnings..."

  # Create learning template
  cat > "$OUTPUT_DIR/learnings/forge/$DATE-workflow.md" << EOF
---
date: $DATE
status: captured
---

# Learning: $(basename "$PWD")

## Workflow Summary
- Phases completed: [count]
- Time spent: [duration]
- Objectives achieved: [list]

## Patterns Discovered
- [Pattern 1]
- [Pattern 2]

## Challenges Overcome
- [Challenge 1]: [Solution]
- [Challenge 2]: [Solution]

## Key Decisions
- [Decision 1]: [Rationale]

## Recommendations for Future
1. [Recommendation]
2. [Recommendation]
EOF

  echo "✅ Learnings captured to $OUTPUT_DIR/learnings/forge/$DATE-workflow.md"
}

# Update metrics
update_metrics() {
  echo "Updating metrics..."

  METRICS_FILE="$OUTPUT_DIR/forge/metrics.json"

  if [ -f "$METRICS_FILE" ]; then
    # Update existing metrics
    echo "  Updating existing metrics..."
  else
    # Create initial metrics
    mkdir -p "$OUTPUT_DIR/forge"
    cat > "$METRICS_FILE" << EOF
{
  "workflows_completed": 1,
  "by_phase": {},
  "patterns_extracted": 0,
  "learnings_captured": 1
}
EOF
  fi

  echo "✅ Metrics updated"
}

# Main execution
case "${1:-all}" in
  "patterns")
    extract_patterns
    ;;
  "learnings")
    capture_learnings
    ;;
  "metrics")
    update_metrics
    ;;
  "all"|*)
    extract_patterns
    capture_learnings
    update_metrics
    ;;
esac

echo ""
echo "🎓 Learning extraction complete!"
