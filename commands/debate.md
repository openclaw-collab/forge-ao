---
name: forge:debate
description: Execute or manage structured debate for current phase
argument-hint: "[--status|--plan|--run|--check|--id <id>]"
disable-model-invocation: true
---

# /forge:debate

Manage structured debate for the current phase. Debates are mandatory gates that must complete before phase completion.

## Usage

```bash
# Check debate status
/forge:debate --status

# Generate debate plan only (AO mode)
/forge:debate --plan --id <debate-id>

# Run debate in current session (standalone)
/forge:debate --run --id <debate-id>

# Check if debate gate passes
/forge:debate --check --id <debate-id>

# Initialize new debate
/forge:debate --init --phase <phase> --topic "<topic>"
```

## State Update Protocol

**ON INIT:**
```bash
DEBATE_ID="${PHASE}-$(date +%Y%m%d-%H%M%S)"
mkdir -p "docs/forge/debate/$DEBATE_ID"
.claude/forge/scripts/forge-debate.mjs init --id "$DEBATE_ID" --phase "$PHASE"
```

## Debate Lifecycle

```
INIT → PLAN → [AO Spawn / Standalone Run] → CHECK → COMPLETE
         │                                    │
         ▼                                    ▼
   debate-plan.md                      All roles written?
   (role prompts)                      └──▶ Gate passes
```

## Commands

### `--status`

Show current debate state:

```
Debate Status: brainstorm-20260115-143022
═══════════════════════════════════════════════════
Phase: brainstorm
Topic: "Add user dashboard"
Status: IN_PROGRESS

Artifacts:
  ✅ debate-plan.md     (exists)
  ⏳ advocate.md        (pending)
  ⏳ skeptic.md         (pending)
  ⏳ operator.md        (pending)
  ⏳ synthesis.md       (pending)

Gate: NOT PASSED (3/5 artifacts)
Next: Generate role outputs
```

### `--plan` (AO Mode)

Generate debate plan without executing:

```bash
/forge:debate --plan --id brainstorm-20260115-143022
```

Creates:
- `docs/forge/debate/<id>/debate-plan.md`

Outputs AO spawn commands:
```bash
## AO Debate Execution Plan

Run these commands to execute debate:

```bash
ao spawn <project> "FORGE DEBATE: Write advocate.md for debate <id>"
ao spawn <project> "FORGE DEBATE: Write skeptic.md for debate <id>"
ao spawn <project> "FORGE DEBATE: Write operator.md for debate <id>"
ao spawn <project> "FORGE DEBATE: Write synthesis.md for debate <id>"
```
```

### `--run` (Standalone Mode)

Execute full debate in current session:

```bash
/forge:debate --run --id brainstorm-20260115-143022
```

Executes sequentially:
1. **Advocate** → writes `advocate.md`
2. **Skeptic** → writes `skeptic.md`
3. **Operator** → writes `operator.md`
4. **Synthesizer** → writes `synthesis.md`

Each role runs in sequence with the system prompt from `debate-plan.md`.

### `--check`

Check if debate gate passes:

```bash
/forge:debate --check --id brainstorm-20260115-143022
# Returns: PASSED | FAILED
```

**Gate Criteria:**
- All 5 required files exist
- `synthesis.md` includes decision
- `synthesis.md` includes kill-switch criteria
- `synthesis.md` includes fallback plan

### `--init`

Initialize new debate:

```bash
/forge:debate --init --phase brainstorm --topic "Add user dashboard"
```

Creates debate directory structure and initial plan template.

## Debate Directory Structure

```
docs/forge/debate/
└── <phase>-<timestamp>/
    ├── debate-plan.md      # Debate structure and role prompts
    ├── advocate.md         # Case FOR the approach
    ├── skeptic.md          # Concerns and risks
    ├── operator.md         # Feasibility assessment
    └── synthesis.md        # Final decision
```

## AO Mode Behavior

In AO mode (AO_SESSION set):
- `--plan` generates debate plan and outputs AO commands
- `--run` is disabled (FORGE never spawns debate agents internally)
- AO executes `ao spawn` commands externally
- FORGE waits for files and checks completion

## Standalone Mode Behavior

In standalone mode (no AO_SESSION):
- `--plan` generates debate plan
- `--run` executes full debate sequentially in session
- All roles run in same session
- No external spawning

## Required Skills

**REQUIRED:** `@forge-debate`

## Integration with Phases

Each phase can have a debate gate:

| Phase | Debate Trigger | Purpose |
|-------|---------------|---------|
| brainstorm | Mandatory | Select best approach |
| design | Optional | UI/UX tradeoffs |
| plan | Optional | Implementation strategy |
| review | Optional | Quality vs timeline |

## Metadata Sync

When AO_SESSION is set, debate status syncs to AO metadata:
- `forge_debate_id`
- `forge_debate_phase`
- `forge_debate_status` (pending|running|complete)
- `forge_debate_pending` (true|false)
