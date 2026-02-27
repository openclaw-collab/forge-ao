---
name: forge:learn
description: Capture patterns, learnings, and complete workflow - AO-native
disable-model-invocation: true
---

# /forge:learn

Continuous learning with pattern extraction and memory updates. Final phase - marks workflow complete. AO-native only - no standalone mode, no prompts, file-based state.

---

## Phase Entry Protocol

### Step 1: Read Prerequisites

```bash
# Read these files before execution:
cat docs/forge/knowledge/decisions.md
cat docs/forge/knowledge/constraints.md
cat docs/forge/knowledge/risks.md
cat docs/forge/review-report.md
cat docs/forge/handoffs/review-to-learn.md
```

### Step 2: Read All Phase Artifacts

```bash
# Read all phase outputs for pattern extraction
cat docs/forge/phases/brainstorm.md
cat docs/forge/phases/research.md
cat docs/forge/phases/design.md
cat docs/forge/phases/plan.md
cat docs/forge/phases/test.md
cat docs/forge/phases/validate.md
cat docs/forge/phases/review.md
```

### Step 3: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: learn
phase_status: in_progress
phase_started_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
  - research
  - design
  - plan
  - test
  - build
  - validate
  - review
---
```

---

## Phase Execution

### Step 1: Extract Patterns

Analyze implementation and extract reusable patterns:

```markdown
## Pattern Extraction

### Pattern 1: [Name]

**Category:** frontend/backend/design/architecture
**Context:** [When to use this pattern]
**Quality:** Good/Bad/Mixed

**Implementation:**
```typescript
// Example from codebase
```

**Source Files:**
- [File 1]
- [File 2]

**Why It Works:**
[Explanation]

**When to Apply:**
[Guidance for future use]
```

### Step 2: Write Pattern Files

Create pattern files in `.claude/memory/patterns/`:

```bash
# Create pattern file
PATTERN_ID="pat-$(date +%Y%m%d-%H%M%S)-$(openssl rand -hex 4)"
PATTERN_FILE=".claude/memory/patterns/${PATTERN_ID}.json"

cat > "${PATTERN_FILE}" << 'EOF'
{
  "pattern_id": "${PATTERN_ID}",
  "name": "[pattern-name]",
  "category": "frontend|backend|design|architecture",
  "context": "[When to use this pattern]",
  "implementation": "[How to implement]",
  "example": "[Code example]",
  "success_rate": 0.95,
  "source_workflow": "<workflow-id>",
  "source_files": ["file1.tsx", "file2.ts"],
  "extracted_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "quality": "good|bad|mixed",
  "tags": ["tag1", "tag2"]
}
EOF
```

### Step 3: Capture Learnings

Create learning files in `.claude/memory/learnings/`:

```bash
# Create learning file
LEARNING_ID="lrn-$(date +%Y%m%d-%H%M%S)-$(openssl rand -hex 4)"
LEARNING_FILE=".claude/memory/learnings/${LEARNING_ID}.json"

cat > "${LEARNING_FILE}" << 'EOF'
{
  "learning_id": "${LEARNING_ID}",
  "type": "success|failure|insight|anti-pattern",
  "title": "[Brief title]",
  "context": "[What we were trying to do]",
  "what_happened": "[What actually happened]",
  "why": "[Root cause analysis]",
  "action": "[What to do in the future]",
  "confidence": "high|medium|low",
  "source_workflow": "<workflow-id>",
  "extracted_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
```

### Step 4: Archive Decisions

Ensure all decisions are in `.claude/memory/decisions/`:

```bash
# Create decision file for key workflow decisions
DECISION_ID="dec-$(date +%Y%m%d-%H%M%S)-$(openssl rand -hex 4)"
DECISION_FILE=".claude/memory/decisions/${DECISION_ID}.json"

cat > "${DECISION_FILE}" << 'EOF'
{
  "decision_id": "${DECISION_ID}",
  "decision": "[What was decided]",
  "context": "[Why this decision was made]",
  "consequences": ["[Expected outcome 1]", "[Expected outcome 2]"],
  "status": "accepted|pending|rejected",
  "date": "$(date +%Y-%m-%d)",
  "reversibility": "high|medium|low",
  "source_workflow": "<workflow-id>",
  "source_phase": "[brainstorm|research|design|...]",
  "extracted_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
```

### Step 5: Generate Learnings Document

Write to `docs/forge/phases/learn.md`:

```markdown
---
phase: learn
generated_at: "<ISO-timestamp>"
objective: "<workflow objective>"
status: in_progress
---

# Learnings: [Objective]

## Workflow Summary

**Workflow ID:** [ID]
**Completed:** [Date]
**Phases Completed:** 10/10
**Total Duration:** [Duration]

### Key Challenge
[Description of main challenge faced]

### Outcome
[Success/Partial/Failure - with explanation]

## Patterns Extracted

### Pattern: [Pattern Name]
**ID:** [pattern-id]
**Category:** frontend/backend/design/architecture
**Quality:** Good/Bad/Mixed
**Context:** [When to use]

**Implementation:**
```typescript
// Example code
```

**Files:** [Source files]
**Location:** `.claude/memory/patterns/[id].json`

---

### Pattern: [Next Pattern]
...

## Learnings Captured

### Success: [Title]
**ID:** [learning-id]
**What:** [Description of what worked]
**Why:** [Why it worked]
**Apply:** [When to apply in future]
**Confidence:** High/Medium/Low

### Anti-pattern: [Title]
**ID:** [learning-id]
**What:** [What didn't work]
**Why:** [Root cause]
**Avoid:** [How to avoid in future]
**Confidence:** High/Medium/Low

## Decisions Archived

| ID | Decision | Context | Reversibility | Location |
|----|----------|---------|---------------|----------|
| [ID] | [Decision] | [Context] | High/Med/Low | `.claude/memory/decisions/` |

## Knowledge Graph Updates

### Entities Created
- [Entity 1]: [Description]
- [Entity 2]: [Description]

### Relationships Documented
- [Entity 1] --[rel]--> [Entity 2]

### Technologies Tagged
- [tech1], [tech2], [tech3]

## CLAUDE.md Updates

### New Patterns Added
- [Pattern name]: [Where documented]

### Conventions Updated
- [Convention]: [Change made]

### Architecture Decisions
- [Decision]: [Where documented]

## Compounding Effect

This workflow makes future work easier:

| Attempt | Time | Source |
|---------|------|--------|
| First (this workflow) | [X] min | Research + solve + document |
| Second (pattern known) | ~[X/10] min | Search + apply pattern |
| Third (muscle memory) | ~[X/50] min | Pattern known |

## Metrics

### Code Metrics
| Metric | Value |
|--------|-------|
| Files modified | [N] |
| Lines added | [N] |
| Lines removed | [N] |
| Test coverage | [N]% |

### Quality Metrics
| Metric | Value |
|--------|-------|
| Review grade | [A/B/C/D] |
| Critical issues | [N] |
| Tests passing | [N]% |

### Process Metrics
| Metric | Value |
|--------|-------|
| Phases completed | 10/10 |
| Debates triggered | [N] |
| Revisions required | [N] |
```

---

## Phase Exit Protocol

### Step 1: Write Final Learnings Artifact

Write to `docs/forge/learnings.md`:

```markdown
---
phase: learn
completed_at: "<ISO-timestamp>"
objective: "<objective>"
status: complete
workflow_status: complete
---

# Learnings: [Objective]

## Workflow Complete

**Workflow ID:** [ID]
**Completed At:** [ISO timestamp]
**Status:** ✅ COMPLETE

## Summary

**What Was Built:** [Brief description]
**Key Challenge:** [Main obstacle overcome]
**Solution:** [How it was solved]
**Outcome:** [Success metrics]

## Patterns Available for Reuse

| Pattern | Category | Quality | Location |
|---------|----------|---------|----------|
| [Name] | [Cat] | Good | `.claude/memory/patterns/[id].json` |

## Key Learnings

### Do This Again
- [Learning 1]
- [Learning 2]

### Avoid This
- [Anti-pattern 1]
- [Anti-pattern 2]

## Full Learnings Document

See: `docs/forge/phases/learn.md`

## Memory Files Created

| Type | Count | Location |
|------|-------|----------|
| Patterns | [N] | `.claude/memory/patterns/` |
| Learnings | [N] | `.claude/memory/learnings/` |
| Decisions | [N] | `.claude/memory/decisions/` |
```

### Step 2: Archive Workflow

```bash
# Create workflow archive
ARCHIVE_DIR="docs/forge/archive/$(date +%Y%m%d)-${WORKFLOW_ID}"
mkdir -p "${ARCHIVE_DIR}"

# Copy all workflow artifacts
cp docs/forge/active-workflow.md "${ARCHIVE_DIR}/workflow-state.md"
cp docs/forge/brainstorm.md "${ARCHIVE_DIR}/"
cp docs/forge/research.md "${ARCHIVE_DIR}/"
cp docs/forge/design.md "${ARCHIVE_DIR}/"
cp docs/forge/plan.md "${ARCHIVE_DIR}/"
cp docs/forge/test-strategy.md "${ARCHIVE_DIR}/"
cp docs/forge/validation-report.md "${ARCHIVE_DIR}/"
cp docs/forge/review-report.md "${ARCHIVE_DIR}/"
cp docs/forge/learnings.md "${ARCHIVE_DIR}/"

# Copy phases
cp -r docs/forge/phases "${ARCHIVE_DIR}/"

# Copy handoffs
cp -r docs/forge/handoffs "${ARCHIVE_DIR}/"

# Create archive manifest
cat > "${ARCHIVE_DIR}/MANIFEST.md" << EOF
# Workflow Archive: ${WORKFLOW_ID}

**Objective:** [Objective]
**Completed:** $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Status:** Complete

## Artifacts

- brainstorm.md: Decision synthesis
- research.md: Technical validation
- design.md: System and UI design
- plan.md: Implementation plan
- test-strategy.md: Test strategy
- validation-report.md: Validation results
- review-report.md: Code review
- learnings.md: Extracted patterns

## Phases/
Detailed phase outputs

## Handoffs/
Phase transition documents
EOF
```

### Step 3: Reset Workflow State

```bash
# Reset active workflow for next workflow
cat > docs/forge/active-workflow.md << 'EOF'
---
workflow_id: null
current_phase: null
phase_status: idle
last_completed_workflow: "<workflow-id>"
last_completed_at: "<ISO-timestamp>"
---

# FORGE Workflow State

**Status:** IDLE - No active workflow

**Last Completed:** [Workflow ID] at [timestamp]

## Start New Workflow

To begin a new workflow:
```
/forge:brainstorm "your objective"
```
EOF
```

### Step 4: Final Update

```yaml
---
workflow_id: "<workflow-id>"
current_phase: learn
phase_status: completed
phase_started_at: "<ISO-timestamp>"
phase_completed_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
  - research
  - design
  - plan
  - test
  - build
  - validate
  - review
  - learn
workflow_status: complete
archived_at: "<ISO-timestamp>"
archive_location: "docs/forge/archive/[date]-[workflow-id]/"
---
```

---

## Acceptance Criteria

Phase completes when:

- [x] Phase Entry Protocol executed (all reads completed)
- [x] All phase artifacts reviewed
- [x] Patterns extracted to `.claude/memory/patterns/`
- [x] Learnings recorded in `.claude/memory/learnings/`
- [x] Decisions archived in `.claude/memory/decisions/`
- [x] `docs/forge/phases/learn.md` written
- [x] `docs/forge/learnings.md` written
- [x] Workflow archived to `docs/forge/archive/`
- [x] `docs/forge/active-workflow.md` reset to idle
- [x] Workflow marked complete

---

## Workflow Complete

This is the final phase. After completion:

- Workflow is fully documented
- Patterns available for future use
- Knowledge captured to memory
- Archive created for reference
- System ready for new workflow

---

## Required Skill

**REQUIRED:** `@forge-learn`

---

## Key Principles

1. **Pattern Extraction** - Reusable patterns saved to memory
2. **Learning Capture** - Successes and failures documented
3. **Knowledge Graph** - Relationships and entities recorded
4. **No standalone mode** - AO-native only
5. **Non-interactive** - No prompts, no menus, file-based state only
6. **Workflow Archive** - Complete history preserved
7. **Compounding** - Each workflow makes future work easier

---

## File Structure

```
docs/forge/
├── active-workflow.md              # Reset to idle on exit
├── learnings.md                    # Final artifact
├── phases/
│   └── learn.md                   # Detailed learnings
├── handoffs/
│   └── review-to-learn.md         # Input (read)
├── archive/
│   └── [date]-[workflow-id]/      # Complete workflow archive
│       ├── MANIFEST.md
│       ├── brainstorm.md
│       ├── research.md
│       ├── design.md
│       ├── plan.md
│       ├── test-strategy.md
│       ├── validation-report.md
│       ├── review-report.md
│       ├── learnings.md
│       ├── phases/
│       └── handoffs/
└── knowledge/
    ├── decisions.md               # Read on entry
    ├── constraints.md             # Read on entry
    └── risks.md                   # Read on entry

.claude/memory/
├── patterns/
│   └── [pattern-id].json          # Extracted patterns
├── learnings/
│   └── [learning-id].json         # Captured learnings
└── decisions/
    └── [decision-id].json         # Archived decisions
```
