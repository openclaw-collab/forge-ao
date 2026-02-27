---
name: forge:plan
description: Create surgical implementation plans with file-level precision - AO-native
disable-model-invocation: true
---

# /forge:plan

Create detailed, surgical implementation plans with file-level precision. AO-native only - no standalone mode, no prompts, file-based state.

**CRITICAL:** Planning CANNOT begin until system design exists.

---

## Phase Entry Protocol

### Step 1: Read Prerequisites

```bash
# Read these files before execution:
cat docs/forge/knowledge/decisions.md
cat docs/forge/knowledge/constraints.md
cat docs/forge/handoffs/design-to-plan.md
```

### Step 2: Verify System Design Exists

```bash
# CRITICAL: Check that system design exists
if [[ ! -f "docs/forge/phases/design.md" ]]; then
  echo "ERROR: System design not found. Cannot proceed to planning."
  echo "Design phase must complete before planning can begin."
  exit 1
fi

# Read system design
cat docs/forge/phases/design.md
```

### Step 3: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: plan
phase_status: in_progress
phase_started_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
  - research
  - design
---
```

---

## Phase Execution

### Step 1: Analyze System Design

Extract from `docs/forge/phases/design.md`:

```markdown
## Design Analysis for Planning

### Components to Implement
| Component | From Design Section | Complexity | Priority |
|-----------|---------------------|------------|----------|
| [Component A] | Components | High/Med/Low | P0/P1/P2 |
| [Component B] | Components | High/Med/Low | P0/P1/P2 |

### APIs to Implement
| API | Method | Path | Dependencies |
|-----|--------|------|--------------|
| [API 1] | GET/POST | /api/... | [Component X] |

### Data Models to Create
| Model | Fields | Relationships |
|-------|--------|---------------|
| [Model A] | [List] | [Relations] |

### UI Components to Build
| Component | Screen | Data Source |
|-----------|--------|-------------|
| [Component X] | [Screen Y] | [API Z] |
```

### Step 2: Generate Plan Document

Write to `docs/forge/phases/plan.md`:

```markdown
---
phase: plan
generated_at: "<ISO-timestamp>"
objective: "<from design handoff>"
status: in_progress
---

# Plan: [Objective]

## Context

### From Design Phase
[Summary from design-to-plan.md handoff]

### System Design Reference
- Architecture: [Pattern from design]
- Components: [N] to implement
- APIs: [N] to implement
- Data Models: [N] to create

### Constraints Applied
[List relevant constraints from constraints.md]

## Overview

**Approach:** [Brief description of implementation strategy]
**Estimated Effort:** [X hours]
**Risk Level:** Low/Medium/High
**Number of Steps:** [N]

## Prerequisites

- [ ] [Item needed before starting]
- [ ] [Dependency that must be ready]

## Implementation Steps

### Step 1: [Name - e.g., "Create Data Models"]

**Files to Create/Modify:**
- `src/models/[file].ts` - [Purpose]
- `src/types/[file].ts` - [Type definitions]

**Implementation Details:**
```typescript
// Specific code to add
interface EntityName {
  id: string;
  // ... fields from design
}
```

**Validation:**
- TypeScript compiles without errors
- Models match design specification

**Estimated:** [time]
**Blocked by:** None
**Blocks:** Step 2, Step 3

---

### Step 2: [Name - e.g., "Implement API Layer"]

**Files to Create/Modify:**
- `src/api/[file].ts` - [Purpose]
- `src/middleware/[file].ts` - [Purpose]

**Implementation Details:**
```typescript
// API implementation from design contract
```

**Validation:**
- Unit tests pass
- API matches design contract

**Estimated:** [time]
**Blocked by:** Step 1
**Blocks:** Step 4

---

### Step 3: [Name]
...

## Dependency Graph

```
Step 1 ──┬──► Step 2 ───► Step 4 ───► Step 6
         │       │
         └──► Step 3 ───► Step 5
```

## Surgical Change Summary

| File | Change Type | Lines (est) | Purpose |
|------|-------------|-------------|---------|
| `src/...` | Create/Modify/Delete | ~X | [Purpose] |

## Test Strategy per Step

| Step | Unit Tests | Integration Tests | E2E Tests |
|------|------------|-------------------|-----------|
| 1 | [What to test] | - | - |
| 2 | [What to test] | [What to test] | - |

## Rollback Plan

If issues arise during implementation:

### Rollback Step 1
```bash
# Commands to revert Step 1
```

### Rollback Step 2
```bash
# Commands to revert Step 2
```

## Checkpoints

- [ ] Checkpoint 1: After Step [N] - [What to verify]
- [ ] Checkpoint 2: After Step [N] - [What to verify]

## Risk Mitigation

| Risk | Step | Mitigation |
|------|------|------------|
| [Risk from design] | [Step N] | [How to mitigate] |
```

### Step 3: Validate Against Karpathy Guidelines

Check plan against surgical principles:

```markdown
## Karpathy Compliance Check

| Guideline | Status | Notes |
|-----------|--------|-------|
| Minimal surface area | ✅/⚠️/❌ | [Files touched] |
| Clear ordering | ✅/⚠️/❌ | [Dependencies clear] |
| Testable chunks | ✅/⚠️/❌ | [Each step verifiable] |
| Rollback plan | ✅/⚠️/❌ | [Rollback defined] |
| Lines per change | ✅/⚠️/❌ | [Avg lines per file] |
```

---

## Phase Exit Protocol

### Step 1: Write Final Plan Artifact

Write to `docs/forge/plan.md`:

```markdown
---
phase: plan
completed_at: "<ISO-timestamp>"
objective: "<objective>"
status: complete
---

# Plan: [Objective]

## Summary

**Total Steps:** [N]
**Estimated Effort:** [X hours]
**Risk Level:** Low/Medium/High
**Files to Modify:** [N]
**Files to Create:** [N]

## Quick Reference

### Step Order
1. [Step 1 Name]
2. [Step 2 Name]
3. ...

### Critical Path
[Step X] → [Step Y] → [Step Z]

### Parallel Work
- Track A: [Steps]
- Track B: [Steps]

## Key Decisions

| Decision | Rationale | Impact |
|----------|-----------|--------|
| [Decision 1] | [Why] | [What it affects] |

## Full Plan

See: `docs/forge/phases/plan.md`
```

### Step 2: Write Handoff Document

Write to `docs/forge/handoffs/plan-to-test.md`:

```markdown
---
from_phase: plan
to_phase: test
generated_at: "<ISO-timestamp>"
workflow_id: "<workflow-id>"
status: final
---

# Phase Handoff: plan → test

## Summary

### What Was Done
Created surgical implementation plan with [N] steps, [X] files to modify.

### Key Outcomes
- Implementation steps defined
- Dependencies mapped
- Test approach per step specified
- Rollback plan documented

## Implementation Overview

### Steps Summary
| Step | Name | Effort | Risk |
|------|------|--------|------|
| 1 | [Name] | X min | Low/Med/High |
| 2 | [Name] | X min | Low/Med/High |

### Critical Path
[Which steps must happen in sequence]

## Test Requirements by Step

| Step | What to Test | Test Type | Priority |
|------|--------------|-----------|----------|
| 1 | [Description] | Unit | P0 |
| 2 | [Description] | Unit/Integration | P0 |

## Risk Areas for Testing Focus

| Risk | Step | Suggested Test Approach |
|------|------|------------------------|
| [Risk] | [Step N] | [Approach] |

## Artifacts Produced

| Artifact | Location | Status |
|----------|----------|--------|
| Detailed Plan | docs/forge/phases/plan.md | Complete |
| Plan Summary | docs/forge/plan.md | Complete |

## Reference Materials

- Phase output: `docs/forge/phases/plan.md`
- System Design: `docs/forge/phases/design.md`
- Design Handoff: `docs/forge/handoffs/design-to-plan.md`

## Sign-off

Phase completed: Yes
Blocked by: None
Ready to proceed: Yes
```

### Step 3: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: plan
phase_status: completed
phase_started_at: "<ISO-timestamp>"
phase_completed_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
  - research
  - design
  - plan
next_phase: test
---
```

## Conditional Debate Gate

**TRIGGER CONDITIONS:**

Per `workflows/forge-workflow.json`, debate trigger mode is `explicit_only` for plan phase.
Debate only runs when explicitly requested via `--debate` flag.

**CLI FLAGS:**

```bash
# Request debate for planning decision
/forge:plan "objective" --debate

# Default behavior - no debate
/forge:plan "objective"
```

**When to Use `--debate`:**
- Plan requires overriding a design decision
- Implementation approach is contentious
- High-risk changes with significant rollback complexity
- Multiple implementation paths with unclear tradeoffs

---

## Acceptance Criteria

Phase completes when:

- [x] Phase Entry Protocol executed (all reads completed)
- [x] System design verified to exist
- [x] Existing codebase analyzed
- [x] All files to modify identified
- [x] Changes specified file-by-file
- [x] Dependencies mapped and ordered
- [x] Test approach defined for each step
- [x] Effort estimated for each step
- [x] Total effort estimated
- [x] Rollback plan documented
- [x] Karpathy guidelines compliance checked
- [x] Debate gate evaluated (if --debate flag used)
- [x] `docs/forge/phases/plan.md` written
- [x] `docs/forge/plan.md` written
- [x] `docs/forge/handoffs/plan-to-test.md` written
- [x] `docs/forge/active-workflow.md` updated

---

## Usage

```bash
/forge:plan "implement user profile system"
/forge:plan "add dashboard metrics"
/forge:plan "refactor authentication flow"

# Debate control flags
/forge:plan "objective" --debate      # Request debate for this plan
```

---

## Next Phase

Auto-proceeds to: `/forge:test` (test strategy)

---

## Required Skill

**REQUIRED:** `@forge-plan`

---

## Key Principles

1. **System Design Required** - Cannot plan without design
2. **Surgical Precision** - Minimal changes, clear ordering
3. **No standalone mode** - AO-native only
4. **Non-interactive** - No prompts, no menus, file-based state only
5. **Testable chunks** - Each step independently verifiable
6. **Rollback ready** - Every step has undo plan

---

## File Structure

```
docs/forge/
├── active-workflow.md              # Updated on entry/exit
├── plan.md                         # Final artifact
├── phases/
│   ├── design.md                  # Input (read - REQUIRED)
│   └── plan.md                    # Detailed plan
├── handoffs/
│   ├── design-to-plan.md          # Input (read)
│   └── plan-to-test.md            # Output (write)
└── knowledge/
    ├── decisions.md               # Read on entry
    └── constraints.md             # Read on entry
```
