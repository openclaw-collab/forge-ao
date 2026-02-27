---
name: forge:start
description: Start the full FORGE 10-phase workflow with AO-native debate gates
disable-model-invocation: true
---

# /forge:start

**Entry point for the AO-native FORGE workflow.** Auto-detects workspace state and guides through all 10 phases with mandatory debate gates.

## CRITICAL RULE: No Internal Subagents in AO Mode

**In AO mode (AO_SESSION set), FORGE NEVER spawns internal subagents.**

FORGE only:
1. Generates debate plans and options
2. Outputs `ao spawn` commands for AO to execute
3. Writes artifacts to workspace
4. Syncs metadata to AO

AO handles:
- Session lifecycle
- Debate execution (via `ao run-debate` or `ao spawn`)
- CI/review routing
- Parallel task orchestration

## State Update Protocol

**ON ENTRY:**
```bash
# Initialize workflow state if not exists
.claude/forge/scripts/forge-state.sh init \
  --objective "$ARGUMENTS" \
  --phase initialize \
  --branch "$(git branch --show-current)"

# Set phase to initialize
.claude/forge/scripts/forge-state.sh set-phase initialize
```

**ON EXIT:**
```bash
# Mark phase complete and set next
.claude/forge/scripts/forge-state.sh complete-phase
.claude/forge/scripts/forge-state.sh set-next brainstorm
```

## Usage

```bash
# Start full workflow (auto-detects mode)
/forge:start "Build a user dashboard"

# Start with options
/forge:start "API integration" --level=intelligent --karthy-strict
```

## AO Mode Detection

FORGE detects AO automatically via `AO_SESSION`:

```bash
if [ -n "$AO_SESSION" ]; then
  MODE="ao"
  echo "AO mode: generating plans, AO executes"
  # NEVER spawn internal subagents
else
  MODE="standalone"
  echo "Standalone mode: full self-contained execution"
fi
```

### AO Mode Behavior (REQUIRED)

| Behavior | AO Mode | Standalone |
|----------|---------|------------|
| Internal subagents | **NEVER** | Can self-debate sequentially |
| Debate execution | AO spawns role sessions | FORGE runs roles in sequence |
| Parallel tasks | Generate AO spawn plan | Execute in session |
| Metadata sync | Yes (AO dashboard) | No |
| State location | Workspace `.claude/forge/` | Same |

## Full 10-Phase Flow with Debate Gates

```
Initialize ──▶ Brainstorm (Debate Gate) ──▶ Research ──▶ Design ──▶ Plan
    │                                               ▲
    ▼                                               │
Learn ◀── Review ◀── Validate ◀── Build ◀── Test ◀─┘

Debate Gates (mandatory):
- Brainstorm: Must complete debate before proceeding
```

## Phase Overview

| Phase | Command | Output | Debate Gate |
|-------|---------|--------|-------------|
| Initialize | `/forge:start` | `active-workflow.md` | No |
| **Brainstorm** | `/forge:brainstorm` | `brainstorm.md` + debate artifacts | **YES (mandatory)** |
| Research | `/forge:research` | `research.md` | No |
| Design | `/forge:design` | `design.md` | Optional |
| Plan | `/forge:plan` | `plan.md` | Optional |
| Test | `/forge:test` | `test-strategy.md` | No |
| Build | `/forge:build` | `build-log.md` | No |
| Validate | `/forge:validate` | `validation-report.md` | No |
| Review | `/forge:review` | `review-report.md` | Optional |
| Learn | `/forge:learn` | `learnings.md` | No |

## Brainstorm Debate Gate (Mandatory)

The Brainstorm phase has a **mandatory debate gate** that must pass before completion.

### AO Mode Flow:

```bash
# 1. FORGE generates options
/forge:brainstorm "Add user dashboard"
# Creates: docs/forge/brainstorm-options.md

# 2. FORGE generates debate plan
# Creates: docs/forge/debate/brainstorm-<id>/debate-plan.md

# 3. FORGE outputs AO commands (does NOT spawn)
echo "Execute debate via:"
echo "  ao run-debate --id brainstorm-<id> --mode parallel"

# 4. AO executes debate (external to FORGE session)
# Spawns: advocate, skeptic, operator, synthesizer sessions

# 5. FORGE detects completion and finalizes
# Reads debate artifacts, writes final brainstorm.md
```

### Standalone Mode Flow:

```bash
# 1. FORGE generates options
/forge:brainstorm "Add user dashboard"

# 2. FORGE runs self-debate sequentially
# Advocate → Skeptic → Operator → Synthesizer
# Each writes to debate directory

# 3. FORGE finalizes
# Writes final brainstorm.md
```

## Automatic Phase Completion

Each phase auto-completes when:
- Phase artifact written to `docs/forge/`
- Acceptance criteria met
- **Debate gate passed** (if applicable)

To pause: `/forge:pause`
To resume: `/forge:continue`

## Workspace Structure Created

```
workspace/
├── .claude/
│   ├── forge/
│   │   ├── active-workflow.md          # State file
│   │   ├── forge-system-prompt.md      # AO protocol
│   │   └── hooks/                      # Workspace-local hooks
│   └── settings.json                   # Hook config
└── docs/forge/
    ├── brainstorm.md                   # Phase artifacts
    ├── research.md
    ├── design.md
    ├── plan.md
    ├── debate/                         # Debate artifacts
    │   └── brainstorm-<id>/
    │       ├── debate-plan.md
    │       ├── advocate.md
    │       ├── skeptic.md
    │       ├── operator.md
    │       └── synthesis.md
    └── ...
```

## Acceptance Criteria

This phase is complete when:
- [ ] FORGE personalized for the project
- [ ] `.claude/forge/active-workflow.md` initialized
- [ ] Project type detected
- [ ] Next phase (brainstorm) set
- [ ] Debate directory structure created
- [ ] `docs/forge/initialization.md` written (optional)

## Status Check

```bash
/forge:status

Current Status:
├── Phase 1: Initialize     ✅ Complete
├── Phase 2: Brainstorm     🔄 In Progress
│   └── Debate Gate:        ⏳ Pending
│       ├── debate-plan.md  ✅
│       ├── advocate.md     ⏳
│       ├── skeptic.md      ⏳
│       ├── operator.md     ⏳
│       └── synthesis.md    ⏳
├── Phase 3: Research       ⏳ Pending
...
```

## Required Skills

- `@forge-init` - Workspace detection
- `@forge-help` - Phase routing
- `@forge-config` - Personalization

## Exit Points

- Workflow completes automatically after Learn phase
- Use `/forge:pause` to pause at any point
- Resume with `/forge:continue`
- Work preserved in `docs/forge/`

## AO Integration Commands

When running under AO:

```bash
# Check debate status
/forge:debate --status

# Generate debate plan for AO execution
/forge:debate --plan --id <debate-id>

# AO executes externally:
#   ao run-debate --id <debate-id>

# Continue after debate completes
/forge:continue
```
