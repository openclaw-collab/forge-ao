---
name: forge:debate
description: Check or regenerate debate artifacts (AO-native)
disable-model-invocation: true
---

# /forge:debate

Manage structured debate artifacts. In AO-native FORGE, debate execution is delegated to AO.

## Usage

```bash
# Check debate status
/forge:debate --status --id <debate-id>

# Generate debate plan
/forge:debate --plan --phase <phase> --topic "<topic>"

# Regenerate debate plan
/forge:debate --regenerate --id <debate-id>
```

## AO-Native Behavior

**FORGE never spawns debate agents.**

FORGE responsibilities:
1. Generate `debate-plan.md` with role prompts
2. Output AO spawn commands (for reference)
3. Check debate completion via file existence
4. Extract decisions from synthesis.md

AO responsibilities:
1. Spawn role sessions (advocate, skeptic, operator, synthesizer)
2. Execute debate in parallel
3. Each role writes its assigned file

## Debate Lifecycle

### Phase 1: Generate Plan

```bash
/forge:debate --plan --phase brainstorm --topic "Authentication approach"
```

Creates:
```
docs/forge/debate/brainstorm-20260115-143022/
└── debate-plan.md
```

### Phase 2: AO Execution (External)

FORGE outputs reference commands:

```markdown
## AO Debate Execution Plan

The following roles should be spawned by AO:

1. **Advocate**: Write advocate.md
   Output: docs/forge/debate/brainstorm-20260115-143022/advocate.md

2. **Skeptic**: Write skeptic.md
   Output: docs/forge/debate/brainstorm-20260115-143022/skeptic.md

3. **Operator**: Write operator.md
   Output: docs/forge/debate/brainstorm-20260115-143022/operator.md

4. **Synthesizer**: Write synthesis.md
   Input: advocate.md, skeptic.md, operator.md
   Output: docs/forge/debate/brainstorm-20260115-143022/synthesis.md
```

### Phase 3: Completion Detection

```bash
/forge:debate --status --id brainstorm-20260115-143022
```

Checks:
- All required files exist
- synthesis.md contains required sections
- Returns: COMPLETE | INCOMPLETE

### Phase 4: Decision Extraction

When debate completes, FORGE:
1. Reads synthesis.md
2. Extracts decisions and risks
3. Appends to `docs/forge/knowledge/decisions.md`
4. Updates `docs/forge/knowledge/risks.md`
5. Unblocks phase in active-workflow.md

## Status Output

```markdown
## Debate Status: brainstorm-20260115-143022

**Phase:** brainstorm
**Status:** INCOMPLETE

### Artifacts
| File | Status |
|------|--------|
| debate-plan.md | ✓ Complete |
| advocate.md | ⏳ Pending |
| skeptic.md | ⏳ Pending |
| operator.md | ⏳ Pending |
| synthesis.md | ⏳ Pending |

### Gate Status
**BLOCKED** - 1/5 artifacts complete

Phase cannot proceed until synthesis.md exists.
```

## Debate Plan Format

```yaml
---
debate_id: "brainstorm-20260115-143022"
phase: "brainstorm"
objective: "Select authentication approach"
status: "pending"
---

## Options Under Consideration

1. **Option A**: JWT with refresh tokens
2. **Option B**: Session-based auth
3. **Option C**: OAuth2 only

## Role Prompts

### Advocate
Write advocate.md arguing FOR the leading option.
Include: Core argument, strengths, comparative advantages.

### Skeptic
Write skeptic.md challenging assumptions.
Include: Critical questions, failure modes, risks.

### Operator
Write operator.md assessing feasibility.
Include: Resources, timeline, constraints.

### Synthesizer
Write synthesis.md reconciling positions.
Include: Final decision, tradeoffs, kill-switch criteria.

## Expected Outputs

- advocate.md
- skeptic.md
- operator.md
- synthesis.md

## Completion Criteria

Debate is complete when synthesis.md contains:
- [ ] Final decision
- [ ] Decision criteria
- [ ] Kill-switch criteria
- [ ] Fallback plan
- [ ] Action items
```

## Blocking Behavior

Debate gates are blocking:

```
Attempting to complete brainstorm phase...

⚠️  DEBATE GATE BLOCKING

Debate synthesis not found.
Phase cannot complete.

Next: /forge:debate --status --id <id>
Or: Wait for AO to complete debate execution
```

## Triggers for Debate

Debate is required when:
1. **Brainstorm phase** - Always mandatory
2. **Major decision** - Affects >3 components
3. **Prior decision challenged** - New information
4. **Risk score ≥ 6** - High×Medium or higher

## Required Reads

- `docs/forge/debate/<id>/debate-plan.md`
- `docs/forge/debate/<id>/advocate.md`
- `docs/forge/debate/<id>/skeptic.md`
- `docs/forge/debate/<id>/operator.md`
- `docs/forge/debate/<id>/synthesis.md`

## Required Writes

- `docs/forge/debate/<id>/debate-plan.md`
- `docs/forge/knowledge/decisions.md` (on completion)
- `docs/forge/knowledge/risks.md` (on completion)
- `.claude/forge/active-workflow.md` (unblock phase)

## See Also

- `/forge:continue` - Resume after debate completes
- `/forge:status` - Check workflow state
