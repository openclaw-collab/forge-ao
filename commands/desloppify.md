---
name: forge:desloppify
description: Spawn an autonomous desloppify agent session for continuous codebase quality improvement (AO-native)
disable-model-invocation: true
---

# /forge:desloppify

Spawn an autonomous desloppify agent session that continuously improves codebase quality. This is an AO-native integration that leverages desloppify's own harness and workflow.

## Usage

```bash
/forge:desloppify                    # Spawn desloppify agent with default target
/forge:desloppify --target 98       # Set target strict score (default: 95)
/forge:desloppify --path src/       # Focus on specific path
/forge:desloppify --continuous      # Run continuously in background (default)
/forge:desloppify --once            # Single scan and fix cycle
```

## AO-Native Behavior

- **Spawns independent agent** - Desloppify runs in its own AO session
- **Uses desloppify's own harness** - No feature reimplementation
- **File-based coordination** - Desloppify state in `.desloppify/`, FORGE state in `.claude/forge/`
- **Non-blocking** - Desloppify agent runs continuously; FORGE continues with other work

## Prerequisites

Desloppify must be installed in the workspace (agent will handle this):

```bash
pip install "desloppify[full]"
```

## How It Works

### Step 1: Spawn Desloppify Agent

FORGE spawns an AO session with the desloppify role:

```bash
ao spawn <project> "Desloppify Agent" \
  --role desloppify \
  --env TARGET_SCORE=95 \
  --env SCAN_PATH=. \
  --env CONTINUOUS=true
```

### Step 2: Agent Bootstraps Desloppify

The spawned agent:

1. Installs desloppify if not present
2. Runs `desloppify update-skill claude` to install skill
3. Starts the desloppify workflow

```bash
# Agent initialization
desloppify scan --path .
desloppify status
```

### Step 3: Desloppify's Autonomous Loop

The agent follows desloppify's native two-loop workflow:

**Outer Loop (periodic):**
```bash
desloppify scan --path .       # Refresh state
desloppify status              # Check if target met
```

**Inner Loop (continuous):**
```bash
desloppify next --explain      # Get next priority issue
# ... agent fixes issue ...
desloppify resolve fixed <id>  # Mark resolved
# Repeat until queue clear or target met
```

### Step 4: Coordination with FORGE

The desloppify agent:
- Writes findings to `.desloppify/state.json`
- Updates scorecard badge (e.g., `assets/quality-scorecard.png`)
- Can be queried by FORGE for status

FORGE can check desloppify status:
```bash
desloppify status --json | jq '.strict_score'
```

## Session Configuration

The spawned agent receives:

```yaml
system_prompt: |
  You are a desloppify quality agent. Your job is to continuously improve
  codebase quality using the desloppify tool.

  Follow the desloppify workflow:
  1. Run `desloppify scan` to establish baseline
  2. Run `desloppify next` to get the next priority issue
  3. Fix the issue properly (not superficially)
  4. Run `desloppify resolve fixed <id>` to mark resolved
  5. Repeat until target score is reached

  Rules:
  - Never game the score - only genuine improvements count
  - Large refactors are fine if needed
  - Small fixes are also valuable
  - Always run tests after changes
  - Commit frequently with descriptive messages

  Target strict score: {{target_score}}
  Current score: check with `desloppify status`

env:
  TARGET_SCORE: "95"
  SCAN_PATH: "."
  AO_FORGE_ROLE: "desloppify"
```

## Integration Points

### With FORGE Workflow

```
... → Build → [Desloppify Agent Spawns] → Review → ...
                    ↓
              Continuously runs
              in background
```

### With CI/CD

The desloppify agent can:
- Run pre-commit checks
- Block PRs if strict_score < target
- Update badge on every commit

### With Other FORGE Phases

- **Build phase**: Desloppify agent fixes issues introduced during build
- **Review phase**: FORGE can query desloppify status as part of review
- **Learn phase**: Desloppify findings feed into pattern extraction

## Required Writes (by Desloppify Agent)

- `.desloppify/state.json` - Persistent state
- `.desloppify/config.json` - Configuration
- `docs/forge/phases/desloppify-status.md` - Status report for FORGE
- `assets/quality-scorecard.png` - Badge (configurable path)

## Status Monitoring

FORGE checks desloppify status:

```bash
# Quick check
if desloppify status --json | jq -e '.strict_score >= 95' > /dev/null; then
  echo "✅ Quality target met"
fi

# Full report
desloppify status
desloppify plan   # Show prioritized plan
```

## Stopping the Agent

```bash
# Kill desloppify session
ao session kill <desloppify-session-id>

# Or from within FORGE
/forge:desloppify --stop
```

## See Also

- Desloppify repo: https://github.com/openclaw-collab/desloppify
- `/forge:review` - Next phase after desloppify
- `/forge:status` - Check FORGE and desloppify status
