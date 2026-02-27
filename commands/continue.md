---
name: forge:continue
description: Resume FORGE workflow from last saved state (AO-native, non-interactive)
disable-model-invocation: true
---

# /forge:continue

Resume a FORGE workflow from its last known state. Deterministic, file-based state recovery.

## Usage

```bash
/forge:continue              # Resume from active-workflow.md
/forge:continue --phase=X    # Resume specific phase
```

## AO-Native State Detection

FORGE reads `.claude/forge/active-workflow.md` to determine state:

```yaml
---
phase: "brainstorm"
phase_status: "in_progress|blocked|completed"
debate_status: "none|pending|complete"
next_phase: "research"
---
```

## Resumption Logic (Non-Interactive)

### Case 1: Phase in_progress

```
Reading active-workflow.md...
Phase: brainstorm
Status: in_progress

Actions:
1. Read phase handoff from previous phase
2. Read canonical knowledge (decisions.md, constraints.md)
3. Read current phase output (if exists)
4. Continue from last completed action
```

### Case 2: Phase blocked (Debate)

```
Reading active-workflow.md...
Phase: brainstorm
Status: blocked
debate_status: pending
debate_id: brainstorm-20260115-143022

Actions:
1. Check debate directory for completion
2. If synthesis.md exists: extract decisions, unblock phase
3. If incomplete: remain blocked, report status
```

### Case 3: Phase completed

```
Reading active-workflow.md...
Phase: brainstorm
Status: completed
Next: research

Actions:
1. Verify phase handoff exists
2. Begin next phase entry protocol
3. Update active-workflow.md
```

## State Recovery Process

1. **Read active-workflow.md**
   - Extract phase, status, debate_state
   - Validate frontmatter

2. **Read canonical knowledge**
   - `docs/forge/knowledge/decisions.md`
   - `docs/forge/knowledge/constraints.md`
   - `docs/forge/knowledge/assumptions.md`
   - `docs/forge/knowledge/risks.md`

3. **Read phase handoff** (if not first phase)
   - `docs/forge/handoffs/<prev>-to-<current>.md`
   - Extract TODO list and constraints

4. **Determine next action**
   - Based on phase_status and file existence
   - No interactive prompts

## Debate Blocking

When debate is incomplete:

```
Status: BLOCKED on debate
debate_id: brainstorm-20260115-143022

Missing artifacts:
- advocate.md: pending
- skeptic.md: pending
- operator.md: pending
- synthesis.md: pending

Phase cannot complete until debate synthesis exists.
FORGE will re-check on next /forge:continue
```

## Output Format

```markdown
## Workflow Resumption

**Phase:** brainstorm
**Status:** in_progress
**Last Updated:** 2026-01-15T14:30:00Z

### Context Loaded
- ✓ decisions.md (3 active decisions)
- ✓ constraints.md (2 hard constraints)
- ✓ assumptions.md (1 open assumption)
- ✓ risks.md (2 medium risks)

### From Previous Handoff
**Locked Decisions:**
- D1: Use React for frontend

**Open Assumptions:**
- A1: API will support pagination

**TODO for this Phase:**
1. [x] Define user personas
2. [ ] Explore UI approaches
3. [ ] Generate debate plan

### Next Action
Generate debate plan for brainstorm phase.
```

## Error Handling

### No Active Workflow

```
Error: No active workflow found
Location checked: .claude/forge/active-workflow.md

To start a new workflow:
/forge:start "feature description"
```

### Corrupted State

```
Error: Invalid frontmatter in active-workflow.md
Attempting recovery from phase output files...

Recovered: Phase appears to be "design"
Last artifact: docs/forge/phases/design.md

Recommend: /forge:start to reinitialize
```

## Required Reads

- `.claude/forge/active-workflow.md`
- `docs/forge/knowledge/decisions.md`
- `docs/forge/knowledge/constraints.md`
- `docs/forge/handoffs/<prev>-to-<current>.md` (if applicable)

## Required Writes

- Updates to `.claude/forge/active-workflow.md` (if unblocking)
- Phase output files (as work progresses)

## See Also

- `/forge:start` - Initialize new workflow
- `/forge:status` - View workflow state
