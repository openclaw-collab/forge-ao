---
name: forge:help
description: Show current FORGE workflow status, debate gate state, and recommend next steps
disable-model-invocation: true
---

# /forge:help

Smart orchestrator that detects current workflow phase, debate gate status, and recommends next steps.

## Usage

```bash
/forge:help              # Show status and recommendation
/forge:help --status     # Detailed progress view with debate state
/forge:help --reset      # Reset workflow state
/forge:help --debate     # Show debate gate status
/forge:help "how do I..." # Get help with specific topic
```

## Status Detection

The help command analyzes the workspace to determine current state:

### Detection Logic

```
Check for FORGE artifacts:
├── docs/forge/brainstorm.md exists? → Phase 1 complete
├── docs/forge/debate/brainstorm-*/   → Debate in progress
│   ├── debate-plan.md
│   ├── advocate.md
│   ├── skeptic.md
│   ├── operator.md
│   └── synthesis.md
├── docs/forge/research.md exists?   → Phase 2 complete
├── docs/forge/design.md exists?     → Phase 3 complete
├── docs/forge/plan.md exists?       → Phase 4 complete
├── docs/forge/test-strategy.md?     → Phase 5 complete
├── docs/forge/build-log.md?         → Phase 6 complete
├── docs/forge/validation-report.md? → Phase 7 complete
├── docs/forge/review-report.md?     → Phase 8 complete
└── docs/forge/learnings.md?         → Phase 9 complete
```

### Debate Gate Detection

```bash
# Check if debate gate is blocking progress
/forge:help --debate

Output:
═══════════════════════════════════════════════════
Debate Gate Status: Brainstorm
═══════════════════════════════════════════════════

Debate ID: brainstorm-20260115-143022
Status: 🔄 IN PROGRESS

Artifacts:
  ✅ debate-plan.md     (exists)
  ⏳ advocate.md        (pending - AO spawn needed)
  ⏳ skeptic.md         (pending - AO spawn needed)
  ⏳ operator.md        (pending - AO spawn needed)
  ⏳ synthesis.md       (pending - AO spawn needed)

Gate Status: BLOCKED (1/5 complete)

Next Actions:
  AO Mode: Run → ao run-debate --id brainstorm-20260115-143022
  Standalone: Run → /forge:debate --run --id brainstorm-20260115-143022
═══════════════════════════════════════════════════
```

### Workspace States

**New Workspace:**
```
Status: New Project
├── No FORGE artifacts found
├── No active workflow
└── Recommendation: Run /forge:start to begin
```

**In Progress (with Debate Gate):**
```
Status: In Progress - Phase 2: Brainstorm
├── Phase 1: Initialize ✅ Complete
├── Phase 2: Brainstorm 🔄 In Progress
│   ├── Options: ✅ 3 approaches documented
│   └── Debate Gate: ⏳ Pending
│       ├── debate-plan.md  ✅
│       ├── advocate.md     ⏳
│       ├── skeptic.md      ⏳
│       ├── operator.md     ⏳
│       └── synthesis.md    ⏳
├── Phase 3: Research       ⏳ Pending
├── Phase 4: Design         ⏳ Pending
├── Phase 5: Plan           ⏳ Pending
├── Phase 6: Test           ⏳ Pending
├── Phase 7: Build          ⏳ Pending
├── Phase 8: Validate       ⏳ Pending
├── Phase 9: Review         ⏳ Pending
└── Phase 10: Learn         ⏳ Pending
```

## Display Output

### Standard View

```
═══════════════════════════════════════════════════
FORGE Workflow Status
═══════════════════════════════════════════════════

Current Phase: 2/10 - Brainstorm 🔄
Debate Gate: IN PROGRESS

Progress:
[████░░░░░░░░░░░░░░░░] 20%

Recently Completed:
  ✅ Initialize - FORGE configured
  🔄 Brainstorm - 3 approaches, debate in progress

Current:
  🔄 Debate Gate - Waiting for synthesis
      ├─ docs/forge/debate/brainstorm-*/debate-plan.md ✅
      ├─ docs/forge/debate/brainstorm-*/advocate.md ⏳
      ├─ docs/forge/debate/brainstorm-*/skeptic.md ⏳
      ├─ docs/forge/debate/brainstorm-*/operator.md ⏳
      └─ docs/forge/debate/brainstorm-*/synthesis.md ⏳

Pending:
  ⏳ Research, Design, Plan, Test, Build, Validate, Review, Learn

AO Commands (if in AO mode):
  ao run-debate --id brainstorm-20260115-143022

═══════════════════════════════════════════════════
```

### Detailed View (--status)

```
═══════════════════════════════════════════════════
FORGE Workflow - Detailed Status
═══════════════════════════════════════════════════

Project: [Detected from package.json or git]
Type: React + TypeScript
Mode: AO (Agent Orchestrator)
Started: 2026-02-20 14:30
Last Activity: 2026-02-20 16:45

Phase Breakdown:
┌─────────────┬──────────┬─────────────────────────────┐
│ Phase       │ Status   │ Details                     │
├─────────────┼──────────┼─────────────────────────────┤
│ 1. Initialize│ ✅ Done  │ FORGE configured            │
│ 2. Brainstorm│ 🔄 Active│ 3 approaches, debate pending│
│ 3. Research  │ ⏳ Ready │ Awaiting brainstorm debate  │
│ 4. Design    │ ⏳ Ready │ Awaiting research           │
│ 5. Plan      │ ⏳ Ready │ Awaiting design             │
│ 6. Test      │ ⏳ Ready │ Awaiting plan               │
│ 7. Build     │ ⏳ Ready │ Awaiting test strategy      │
│ 8. Validate  │ ⏳ Ready │ Awaiting build              │
│ 9. Review    │ ⏳ Ready │ Awaiting validation         │
│ 10. Learn    │ ⏳ Ready │ Awaiting review             │
└─────────────┴──────────┴─────────────────────────────┘

Debate Status:
├── ID: brainstorm-20260115-143022
├── Status: PENDING
├── Missing: advocate.md, skeptic.md, operator.md, synthesis.md
└── Action: ao run-debate --id brainstorm-20260115-143022

Files:
├── docs/forge/brainstorm-options.md    (2.4 KB)
└── docs/forge/debate/
    └── brainstorm-20260115-143022/
        └── debate-plan.md              (1.8 KB)

═══════════════════════════════════════════════════
```

## Next Step Recommendations

### Phase 2: Brainstorm (Debate Gate)

```
Recommendation: Complete Brainstorm Debate
├── Current: 3 approaches documented
├── Debate Gate: IN PROGRESS
├── Missing: 4 debate artifacts
└── Actions:
    AO Mode:     ao run-debate --id <debate-id>
    Standalone:  /forge:debate --run --id <debate-id>
    Check:       /forge:debate --check --id <debate-id>
```

### Phase 4: Plan

```
Recommendation: Complete Planning
├── Current: Implementation plan in draft
├── Blockers: None detected
├── Next: Finalize plan and proceed to Test
└── Actions:
    [continue]  - Resume planning
    [test]      - Skip to test phase
    [build]     - Skip to build phase
```

## Quick Actions

Common commands based on current state:

```
Quick Actions:
├── /forge:start    - Continue full workflow
├── /forge:brainstorm - Generate options + debate plan
├── /forge:debate --status - Check debate gate
├── /forge:research - Jump to research (if debate done)
├── /forge:plan     - Jump to planning
├── /forge:build    - Start implementation
├── /forge:test     - Run tests
└── /forge:learn    - Capture knowledge
```

## Related Commands

| Command | Purpose |
|---------|---------|
| `/forge:status` | Alias for detailed progress |
| `/forge:debate --status` | Debate gate status only |
| `/forge:next` | Advance to next phase |
| `/forge:start` | Begin from current state |
| `/forge:reset` | Clear workflow state |

## State Reset (--reset)

Reset workflow state (use with caution):

```bash
/forge:help --reset

⚠️  This will clear all FORGE workflow state.
    Existing docs/forge/ files will be preserved.

Reset options:
  [full]      - Clear all state, start fresh
  [phase]     - Reset only current phase
  [debate]    - Reset current debate
  [cancel]    - Keep current state
```

## Required Skill

**REQUIRED:** `@forge-help`
