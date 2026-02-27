# FORGE Agent Orchestrator Integration

**AO-Native Workflow Plugin - Version 2.0.0**

This integration enables FORGE to run as an AO-native workflow system. FORGE is designed exclusively for Agent Orchestrator - there is no standalone mode.

## Core Principles

1. **Files are the source of truth** - All state lives in the workspace
2. **FORGE generates, AO executes** - Debate plans are generated; AO spawns role sessions
3. **Blocking debate gates** - Phases cannot complete until debate synthesis exists
4. **Deterministic resumption** - `/forge:continue` works from file state alone

## Installation

### From within an AO workspace

```bash
# Install FORGE integration
node /path/to/forge/integrations/agent-orchestrator/install.mjs
```

### Via AO project configuration

Add to your `agent-orchestrator.yaml`:

```yaml
projects:
  - name: my-project
    postCreate:
      - "node tools/forge/integrations/agent-orchestrator/install.mjs --workspace ."
    agentConfig:
      systemPromptFile: ".claude/forge/forge-system-prompt.md"
```

## What Gets Installed

1. **System Prompt** → `.claude/forge/forge-system-prompt.md`
   - AO-native FORGE protocol
   - No subagent spawning rules
   - Phase entry/exit protocols

2. **Knowledge Structure** → `docs/forge/knowledge/`
   - `brief.md` - Project context
   - `decisions.md` - Immutable decision registry
   - `constraints.md` - Hard and soft constraints
   - `assumptions.md` - Validated/invalidated assumptions
   - `risks.md` - Risk registry
   - `glossary.md` - Domain terms
   - `traceability.md` - Requirements mapping

3. **State File** → `.claude/forge/active-workflow.md`
   - Current phase and status
   - Debate state tracking
   - Completion tracking

4. **Hooks** → Workspace `.claude/`
   - PreCompact hook for session recovery
   - Safety hooks (env/lockfile protection)

## Workflow Phases

```
Initialize → Brainstorm (Debate Gate) → Research → Design → Plan → Test → Build → Validate → Review → Learn
```

### Debate Gate (Mandatory in Brainstorm)

Brainstorm phase requires structured debate:

1. **FORGE generates debate plan**
   - Location: `docs/forge/debate/brainstorm-{timestamp}/debate-plan.md`

2. **AO spawns debate roles**
   - Advocate writes: `advocate.md`
   - Skeptic writes: `skeptic.md`
   - Operator writes: `operator.md`
   - Synthesizer writes: `synthesis.md`

3. **FORGE blocks until complete**
   - Phase status: `blocked`
   - Debate status: `pending`
   - Resumes when `synthesis.md` exists

4. **FORGE extracts decisions**
   - Appends to `docs/forge/knowledge/decisions.md`
   - Updates `docs/forge/knowledge/risks.md`
   - Proceeds to next phase

## File Structure

```
workspace/
├── .claude/
│   └── forge/
│       ├── forge-system-prompt.md
│       └── active-workflow.md
└── docs/
    └── forge/
        ├── knowledge/
        │   ├── brief.md
        │   ├── decisions.md
        │   ├── constraints.md
        │   ├── assumptions.md
        │   ├── risks.md
        │   ├── glossary.md
        │   └── traceability.md
        ├── phases/
        │   ├── brainstorm.md
        │   ├── research.md
        │   ├── design.md
        │   ├── plan.md
        │   ├── test.md
        │   ├── build.md
        │   ├── validate.md
        │   ├── review.md
        │   └── learn.md
        ├── handoffs/
        │   ├── init-to-brainstorm.md
        │   ├── brainstorm-to-research.md
        │   ├── research-to-design.md
        │   ├── design-to-plan.md
        │   ├── plan-to-test.md
        │   ├── test-to-build.md
        │   ├── build-to-validate.md
        │   ├── validate-to-review.md
        │   └── review-to-learn.md
        └── debate/
            └── brainstorm-{timestamp}/
                ├── debate-plan.md
                ├── advocate.md
                ├── skeptic.md
                ├── operator.md
                └── synthesis.md
```

## Commands

| Command | Phase | Debate Gate |
|---------|-------|-------------|
| `/forge:start` | Initialize | No |
| `/forge:brainstorm` | Brainstorm | **Mandatory** |
| `/forge:research` | Research | Conditional |
| `/forge:design` | Design | Conditional |
| `/forge:plan` | Plan | Conditional |
| `/forge:test` | Test Strategy | No |
| `/forge:build` | Build | Test gate |
| `/forge:validate` | Validate | Conditional |
| `/forge:review` | Review | Conditional |
| `/forge:learn` | Learn | No |
| `/forge:continue` | Resume | - |
| `/forge:status` | Check state | - |

## State Management

### Active Workflow File

`.claude/forge/active-workflow.md`:

```yaml
---
workflow: forge
version: "2.0.0"
objective: "Build user dashboard"
phase: brainstorm
phase_status: in_progress|blocked|completed
started_at: "2026-01-15T10:30:00Z"
last_updated: "2026-01-15T11:00:00Z"
completed_phases: [init]
next_phase: research
debate_id: brainstorm-20260115-143022
debate_status: pending
---

## Current Phase Context
[Summary of current work]

## Blockers
[Any blockers preventing completion]

## Next Actions
[Ordered list of remaining actions]
```

## Session Resumption

When a session is interrupted:

1. User runs `/forge:continue`
2. FORGE reads `active-workflow.md`
3. FORGE reads canonical knowledge
4. FORGE reads phase handoff
5. FORGE determines next action from file state
6. No chat context required

## Debate Role Agents

AO spawns these agents during debate:

- **@advocate** - Writes `docs/forge/debate/{id}/advocate.md`
- **@skeptic** - Writes `docs/forge/debate/{id}/skeptic.md`
- **@operator** - Writes `docs/forge/debate/{id}/operator.md`
- **@synthesizer** - Writes `docs/forge/debate/{id}/synthesis.md`

FORGE never spawns these agents. It generates the debate plan and detects completion via file existence.

## Environment Variables

FORGE uses these AO-injected variables:

| Variable | Purpose |
|----------|---------|
| `AO_SESSION` | Session identifier |
| `AO_DATA_DIR` | AO metadata directory |
| `AO_PROJECT` | Project name |

## Troubleshooting

### Phase blocked on debate

```
Status: BLOCKED on debate
debate_id: brainstorm-20260115-143022

Missing: synthesis.md

Phase will resume when debate completes.
Run /forge:continue to re-check.
```

### No active workflow

```
Error: No active workflow found

Start with: /forge:start "objective"
```

### Handoff missing

```
Error: Handoff not found
Expected: docs/forge/handoffs/{prev}-to-{current}.md

Previous phase may not have completed properly.
```

## Files

- `forge-system-prompt.md` - AO-native FORGE protocol
- `install.mjs` - Installation script
- `README.md` - This file
