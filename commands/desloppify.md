---
name: forge:desloppify
description: Quality hardening phase - Run desloppify to improve codebase quality (AO-native)
disable-model-invocation: true
---

# /forge:desloppify

Run desloppify quality harness to systematically improve codebase quality. This is an AO-native command that integrates with the desloppify tool for maintaining existing code.

## Usage

```bash
/forge:desloppify                    # Run quality scan and improvement loop
/forge:desloppify --target 95       # Set target strict score (default: 95)
/forge:desloppify --path src/       # Scan specific path
/forge:desloppify --quick           # Quick mode: only T1/T2 issues
```

## AO-Native Behavior

- **No standalone mode** - Requires desloppify to be installed in workspace
- **Non-interactive** - Uses file-based state and exit codes
- **Blocking** - Phase completes when target score is reached or max iterations exceeded

## Prerequisites

Ensure desloppify is installed:

```bash
pip install "desloppify[full]"
desloppify update-skill claude  # Install skill for Claude Code
```

## Phase Execution

### Step 1: Baseline Scan

```bash
desloppify scan --path .
desloppify status
```

Capture current scores and identify improvement areas.

### Step 2: Target Score Check

Compare current strict score against target (default: 95):

```bash
CURRENT_SCORE=$(desloppify status --json | jq '.strict_score')
if [ "$CURRENT_SCORE" -ge "95" ]; then
  echo "✅ Quality target met"
  exit 0
fi
```

### Step 3: Improvement Loop

While score < target and iterations < max:

```bash
MAX_ITERATIONS=10
ITERATION=0

while [ $ITERATION -lt $MAX_ITERATIONS ]; do
  # Get next priority item
  desloppify next --explain

  # Fix the issue (as determined by agent)
  # ... make code changes ...

  # Mark as resolved
  desloppify resolve fixed <finding-id>

  # Re-scan to check progress
  desloppify scan --path .

  # Check if target met
  CURRENT_SCORE=$(desloppify status --json | jq '.strict_score')
  if [ "$CURRENT_SCORE" -ge "95" ]; then
    echo "✅ Quality target met"
    break
  fi

  ITERATION=$((ITERATION + 1))
done
```

### Step 4: Final Validation

```bash
# Generate final scorecard
desloppify scan --path . --badge-path assets/quality-scorecard.png

# Verify all T1/T2 issues resolved
desloppify status --json | jq '.tiers.T1.open, .tiers.T2.open'
```

## Required Writes

- Quality report: `docs/forge/phases/desloppify.md`
- Scorecard badge: `assets/quality-scorecard.png` (or configured path)
- Handoff: `docs/forge/handoffs/desloppify-to-review.md`

## Phase Handoff Output

```markdown
---
from_phase: desloppify
to_phase: review
generated_at: "<ISO-timestamp>"
---

# Phase Handoff: desloppify → review

## Quality Metrics

| Metric | Before | After | Target |
|--------|--------|-------|--------|
| Strict Score | 78 | 96 | 95 |
| T1 Issues | 12 | 0 | 0 |
| T2 Issues | 8 | 1 | 0 |
| T3 Issues | 15 | 12 | - |
| T4 Issues | 5 | 5 | - |

## Key Improvements

- Fixed 12 unused imports and variables
- Resolved 7 naming inconsistencies
- Refactored 3 overly complex functions
- Removed 2 god components (split into smaller modules)

## Risks Accepted

| Risk | Rationale |
|------|-----------|
| T3: Near-duplicate in utils/ | Intentional - different use cases |
| T4: Auth module complexity | Requires architectural change - deferred |

## Next Phase Notes

Codebase now meets quality standards for review phase.
```

## Integration with FORGE Workflow

### As a Standalone Phase

```
... → Build → /forge:desloppify → Review → ...
```

### As Continuous Quality

During Build phase, periodically run:

```bash
/forge:desloppify --quick  # Only T1/T2 auto-fixable issues
```

## Exit Criteria

Phase completes when:
- [ ] Strict score ≥ target (default 95)
- [ ] All T1 issues resolved
- [ ] T2 issues ≤ threshold (default: 2)
- [ ] Scorecard badge generated
- [ ] Phase handoff written

## Required Skills

**REQUIRED:** `@desloppify`

## See Also

- `/forge:review` - Next phase after quality hardening
- `/forge:build` - Preceding phase where code is written
- desloppify docs: https://github.com/openclaw-collab/desloppify
