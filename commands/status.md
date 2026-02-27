---
name: forge:status
description: Show detailed FORGE workflow progress, debate gate status, and current phase
argument-hint: "[--verbose|--debate|--json]"
disable-model-invocation: true
---

# /forge:status

Show detailed progress of the current FORGE workflow including debate gate status.

## Usage

```bash
/forge:status           # Show current status
/forge:status --verbose # Show detailed status with debate artifacts
/forge:status --debate  # Show only debate gate status
/forge:status --json    # Output as JSON for tooling
```

## Output Sections

### 1. Workflow Overview

```
═══════════════════════════════════════════════════
FORGE Workflow Status v0.5.0
═══════════════════════════════════════════════════

Current Phase: 2/10 - Brainstorm
Mode: AO (Agent Orchestrator)
Status: DEBATE_GATE_PENDING

Progress: [██░░░░░░░░░░░░░░░░░░] 20%

Phases:
  ✅ Initialize    (complete)
  🔄 Brainstorm    (in progress - debate pending)
  ⏳ Research      (pending)
  ⏳ Design        (pending)
  ⏳ Plan          (pending)
  ⏳ Test          (pending)
  ⏳ Build         (pending)
  ⏳ Validate      (pending)
  ⏳ Review        (pending)
  ⏳ Learn         (pending)
```

### 2. Debate Gate Status

```
Debate Gate: Brainstorm
───────────────────────────────────────────────────
Debate ID: brainstorm-20260115-143022
Topic: "Add user dashboard"
Status: PENDING

Artifacts Check:
  ✅ debate-plan.md     (exists, 1.8 KB)
  ⏳ advocate.md        (missing)
  ⏳ skeptic.md         (missing)
  ⏳ operator.md        (missing)
  ⏳ synthesis.md       (missing)

Completion: 1/5 (20%)
Gate: BLOCKED

Next Step:
  AO: ao run-debate --id brainstorm-20260115-143022
  Standalone: /forge:debate --run --id brainstorm-20260115-143022
```

### 3. Artifact Inventory

```
Artifacts:
├── docs/forge/
│   ├── brainstorm-options.md        (2.4 KB)
│   └── debate/
│       └── brainstorm-20260115-143022/
│           ├── debate-plan.md       (1.8 KB)
│           ├── advocate.md          (missing)
│           ├── skeptic.md           (missing)
│           ├── operator.md          (missing)
│           └── synthesis.md         (missing)
```

### 4. State File

```
Active Workflow State (.claude/forge/active-workflow.md):
  Workflow: forge
  Version: 0.5.0
  Objective: "Build user dashboard"
  Phase: brainstorm
  Status: in_progress
  Started: 2026-01-15T14:30:00Z
  Next Phase: research (blocked by debate gate)
  Debate ID: brainstorm-20260115-143022
```

## JSON Output (--json)

```bash
/forge:status --json
```

Output:
```json
{
  "workflow": "forge",
  "version": "0.5.0",
  "current_phase": "brainstorm",
  "phase_number": 2,
  "total_phases": 10,
  "progress_percent": 20,
  "mode": "ao",
  "status": "debate_gate_pending",
  "debate_gate": {
    "phase": "brainstorm",
    "debate_id": "brainstorm-20260115-143022",
    "status": "pending",
    "artifacts": {
      "debate-plan.md": {"exists": true, "size": 1800},
      "advocate.md": {"exists": false},
      "skeptic.md": {"exists": false},
      "operator.md": {"exists": false},
      "synthesis.md": {"exists": false}
    },
    "completion": "1/5",
    "blocked": true
  },
  "phases": [
    {"id": "init", "name": "Initialize", "status": "complete"},
    {"id": "brainstorm", "name": "Brainstorm", "status": "in_progress"},
    {"id": "research", "name": "Research", "status": "pending"},
    ...
  ]
}
```

## Checking Specific Debate

```bash
# Check specific debate by ID
/forge:status --debate --id brainstorm-20260115-143022

# Or use debate command
/forge:debate --status --id brainstorm-20260115-143022
```

## Exit Codes

For scripting:
- `0` - Workflow complete, all gates passed
- `1` - Workflow in progress, current phase not complete
- `2` - Debate gate blocking
- `3` - Error reading state

## Required Skill

**REQUIRED:** `@forge-status`
