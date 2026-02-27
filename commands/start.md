---
name: forge:start
description: Initialize FORGE workflow and knowledge structure (AO-native)
disable-model-invocation: true
---

# /forge:start

**Entry point for AO-native FORGE workflow.** Creates canonical knowledge structure and initializes workflow state.

## Usage

```bash
/forge:start "Build a user dashboard"
```

## Behavior

FORGE initializes the workspace for AO-native execution:
1. Creates canonical knowledge structure
2. Initializes active-workflow.md
3. Captures project brief
4. Prepares for debate-driven phases

## No Subagent Spawning

**FORGE never spawns subagents.**

All "parallel" work is output as AO spawn plans for later execution.

## Workflow Initialization

### Step 1: Create Knowledge Structure

```
docs/forge/knowledge/
├── brief.md          # Project context
├── assumptions.md    # Assumption registry
├── decisions.md      # Decision registry
├── constraints.md    # Constraint registry
├── risks.md          # Risk registry
├── glossary.md       # Domain terms
└── traceability.md   # Requirements traceability
```

### Step 2: Initialize State

```yaml
---
workflow: forge
version: "2.0.0"
objective: "Build a user dashboard"
phase: "init"
phase_status: "in_progress"
started_at: "2026-01-15T10:30:00Z"
last_updated: "2026-01-15T10:30:00Z"
completed_phases: []
next_phase: "brainstorm"
debate_id: ""
debate_status: "none"
---

## Current Phase Context
Initializing FORGE workflow for: Build a user dashboard

## Blockers
None

## Next Actions
1. Create knowledge structure
2. Write init-to-brainstorm handoff
3. Complete initialization
```

### Step 3: Write Handoff

Creates: `docs/forge/handoffs/init-to-brainstorm.md`

## Phase Flow

```
Initialize ──▶ Brainstorm (Debate Gate) ──▶ Research ──▶ Design ──▶ Plan
    │                                               ▲
    ▼                                               │
Learn ◀── Review ◀── Validate ◀── Build ◀── Test ◀─┘
```

## Phase Overview

| Phase | Command | Output | Debate Gate |
|-------|---------|--------|-------------|
| Initialize | `/forge:start` | Knowledge structure | No |
| **Brainstorm** | `/forge:brainstorm` | brainstorm.md + debate | **YES (mandatory)** |
| Research | `/forge:research` | research.md | Conditional |
| Design | `/forge:design` | design.md | Conditional |
| Plan | `/forge:plan` | plan.md | Conditional |
| Test | `/forge:test` | test-strategy.md | No |
| Build | `/forge:build` | build-log.md | No (test gate) |
| Validate | `/forge:validate` | validation-report.md | Conditional |
| Review | `/forge:review` | review-report.md | Conditional |
| Learn | `/forge:learn` | learnings.md | No |

## Debate Gate (Mandatory in Brainstorm)

Brainstorm phase requires structured debate:

1. FORGE generates debate plan
2. AO spawns role sessions externally
3. FORGE blocks until synthesis exists
4. FORGE extracts decisions and proceeds

## Design Rule

**System Design must complete before UI/UX Design.**

Design phase has two layers:
1. System Design (architecture, components, data, APIs, auth, failure modes)
2. UI/UX Design (user flows, interfaces, interactions)

## Build Gate

Build phase requires:
- All tests pass before completion
- Internalized Ralph loop (TDD)
- No exceptions

## Exit Criteria

Initialization complete when:
- [ ] All knowledge files exist
- [ ] active-workflow.md initialized
- [ ] Handoff written: init-to-brainstorm

## Status Output

```markdown
## FORGE Initialized

**Objective:** Build a user dashboard
**Phase:** init → brainstorm
**Status:** Complete

### Created
- docs/forge/knowledge/brief.md
- docs/forge/knowledge/assumptions.md
- docs/forge/knowledge/decisions.md
- docs/forge/knowledge/constraints.md
- docs/forge/knowledge/risks.md
- docs/forge/knowledge/glossary.md
- docs/forge/knowledge/traceability.md
- docs/forge/handoffs/init-to-brainstorm.md
- .claude/forge/active-workflow.md

### Next
Run `/forge:brainstorm` to begin exploration with mandatory debate.
```

## Required Writes

- `docs/forge/knowledge/brief.md`
- `docs/forge/knowledge/assumptions.md`
- `docs/forge/knowledge/decisions.md`
- `docs/forge/knowledge/constraints.md`
- `docs/forge/knowledge/risks.md`
- `docs/forge/knowledge/glossary.md`
- `docs/forge/knowledge/traceability.md`
- `docs/forge/handoffs/init-to-brainstorm.md`
- `.claude/forge/active-workflow.md`

## See Also

- `/forge:brainstorm` - Next phase (mandatory debate)
- `/forge:continue` - Resume workflow
- `/forge:status` - Check state
