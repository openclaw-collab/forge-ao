---
name: forge:brainstorm-debate
description: Dedicated debate management for brainstorm phase
disable-model-invocation: true
---

# /forge:brainstorm-debate

Dedicated debate management for the Brainstorm phase. Generates debate plan and manages debate execution.

## Usage

```bash
# Initialize debate for current brainstorm
/forge:brainstorm-debate --init

# Check debate status
/forge:brainstorm-debate --status

# Generate AO execution plan
/forge:brainstorm-debate --plan

# Run self-debate (standalone only)
/forge:brainstorm-debate --run

# Check if debate gate passes
/forge:brainstorm-debate --check

# Reset debate
/forge:brainstorm-debate --reset
```

## Process

### Step 1: Initialize

```bash
/forge:brainstorm-debate --init
```

Reads `docs/forge/brainstorm-options.md` and creates:
- `docs/forge/debate/brainstorm-<id>/debate-plan.md`

### Step 2: Execute Debate

**AO Mode:**
```bash
# Generate plan only
/forge:brainstorm-debate --plan

# Output:
# ao spawn <project> "FORGE: Write advocate.md for debate <id>"
# ao spawn <project> "FORGE: Write skeptic.md for debate <id>"
# ao spawn <project> "FORGE: Write operator.md for debate <id>"
# ao spawn <project> "FORGE: Write synthesis.md for debate <id>"
```

**Standalone Mode:**
```bash
# Run full debate in session
/forge:brainstorm-debate --run
```

### Step 3: Check Completion

```bash
/forge:brainstorm-debate --check
# Returns: PASSED | FAILED
```

## Debate Gate Criteria

Gate passes when all exist:
- `debate-plan.md` (exists)
- `advocate.md` (not empty)
- `skeptic.md` (not empty)
- `operator.md` (not empty)
- `synthesis.md` (includes decision + kill-switch + fallback)

## Required Skills

**REQUIRED:** `@forge-brainstorm`, `@forge-debate`
