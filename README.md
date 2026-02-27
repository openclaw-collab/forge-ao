# FORGE-AO 2.0

**AO-native 10-phase development workflow for Agent Orchestrator.**

FORGE-AO is a purpose-built workflow plugin designed exclusively for Agent Orchestrator (AO). It provides structured, deterministic software development with mandatory debate gates, drift-resistant phase handoffs, and AO-native execution.

---

## AO-Native Principles

FORGE-AO is built on a core philosophy: **Files are the source of truth.**

### Key Principles

1. **No Chat Context Dependency**
   - All state is stored in files, not conversation history
   - Work can resume from any point via `/forge:continue`
   - No "memory" required - everything is documented

2. **AO-Only Execution**
   - Requires `AO_SESSION` environment variable
   - No standalone mode - FORGE runs within AO-managed sessions
   - AO spawns parallel sessions; FORGE detects completion via files

3. **Deterministic Artifacts**
   - Every phase produces documented outputs
   - Debate gates require explicit file completion
   - Phase transitions only occur when artifacts exist

4. **Mandatory Debate Gates**
   - Structured debate required before major decisions
   - FORGE generates debate plans; AO executes debate sessions
   - Completion detected via file existence, not callbacks

---

## Directory Structure

```
.claude/forge/                    # FORGE state (workspace-local)
├── active-workflow.md            # Current workflow state (source of truth)
├── config.json                   # FORGE configuration
├── snapshots/                    # Session checkpoints
│   └── YYYYMMDD-HHMMSS.md
├── archive/                      # Completed workflows
│   └── workflow-<id>.md
└── hooks/                        # FORGE lifecycle hooks
    ├── SessionStart/
    ├── PreToolUse/
    └── PostToolUse/

docs/forge/                       # Workflow artifacts
├── brainstorm.md                 # Phase outputs
├── research.md
├── design.md
├── plan.md
├── test-strategy.md
├── build-log.md
├── validation-report.md
├── review-report.md
└── learnings.md

docs/forge/knowledge/             # Canonical knowledge base
├── brief.md                      # Project brief
├── decisions.md                  # Locked decisions registry
├── constraints.md                # Hard/soft constraints
├── assumptions.md                # Open assumptions
├── risks.md                      # Risk registry
├── glossary.md                   # Domain terminology
└── traceability.md               # Decision traceability

docs/forge/debate/                # Debate artifacts
└── <phase>-<timestamp>/
    ├── debate-plan.md            # FORGE generates this
    ├── advocate.md               # AO-spawned advocate writes
    ├── skeptic.md                # AO-spawned skeptic writes
    ├── operator.md               # AO-spawned operator writes
    └── synthesis.md              # AO-spawned synthesizer writes

docs/forge/handoffs/              # Phase handoff documents
├── init-to-brainstorm.md
├── brainstorm-to-research.md
├── research-to-design.md
└── ...

docs/forge/phases/                # Phase working documents
├── brainstorm-options.md
├── design-spec.md
└── ...
```

---

## How Debate Works

The Debate Gate is FORGE's mechanism for structured decision-making. In AO-native mode, debate is entirely file-driven.

### Debate Lifecycle

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  FORGE Generates │────▶│  AO Spawns      │────▶│  FORGE Detects  │
│  Debate Plan     │     │  Role Sessions  │     │  Completion     │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
debate-plan.md           advocate.md            Phase unblocked
                         skeptic.md
                         operator.md
                         synthesis.md
```

### Phase 1: FORGE Generates Plan

When a phase requires debate (e.g., brainstorm), FORGE:

1. Creates `docs/forge/debate/<phase>-<id>/debate-plan.md`
2. Outputs AO spawn commands for reference
3. Updates `active-workflow.md` with debate status
4. Blocks phase completion

**Debate Plan Contents:**
```yaml
---
debate_id: "brainstorm-20260127-143022"
phase: "brainstorm"
objective: "Select authentication approach"
status: "pending"
---

## Options Under Consideration
1. JWT with refresh tokens
2. Session-based auth
3. OAuth2 only

## Role Prompts
### Advocate
Write advocate.md arguing FOR the leading option...

### Skeptic
Write skeptic.md challenging assumptions...

### Operator
Write operator.md assessing feasibility...

### Synthesizer
Write synthesis.md reconciling positions...

## Expected Outputs
- advocate.md
- skeptic.md
- operator.md
- synthesis.md

## Completion Criteria
Debate complete when synthesis.md contains:
- [ ] Final decision
- [ ] Decision criteria
- [ ] Kill-switch criteria
- [ ] Fallback plan
- [ ] Action items
```

### Phase 2: AO Executes Debate

FORGE outputs reference commands (not executed by FORGE):

```bash
## AO Debate Execution Plan

Execute via AO:
ao spawn <project> "FORGE: Write advocate.md for debate brainstorm-20260127-143022"
ao spawn <project> "FORGE: Write skeptic.md for debate brainstorm-20260127-143022"
ao spawn <project> "FORGE: Write operator.md for debate brainstorm-20260127-143022"
ao spawn <project> "FORGE: Write synthesis.md for debate brainstorm-20260127-143022"
```

Each AO-spawned session:
1. Reads `debate-plan.md`
2. Writes its assigned output file
3. Exits

### Phase 3: FORGE Detects Completion

FORGE checks debate status on:
- `/forge:debate --status --id <id>`
- `/forge:continue`
- Phase completion attempts

**Gate Passes When:**
- All 5 debate files exist and are non-empty
- `synthesis.md` contains required sections
- Decision is documented with kill-switch criteria

**Gate Blocks When:**
- Any file missing
- Synthesis incomplete
- Decision unclear

### Debate Roles

| Role | Writes | Purpose |
|------|--------|---------|
| **Advocate** | `advocate.md` | Argues FOR the leading option |
| **Skeptic** | `skeptic.md` | Probes weaknesses, finds failure modes |
| **Operator** | `operator.md` | Assesses implementation feasibility |
| **Synthesizer** | `synthesis.md` | Produces final decision with rationale |

---

## How /forge:continue Works

The `/forge:continue` command enables session-independent workflow resumption through file-based state recovery.

### State Recovery Process

```
/forge:continue
    │
    ▼
Read active-workflow.md
    │
    ▼
Parse phase, status, debate_state
    │
    ▼
Load canonical knowledge
(decisions.md, constraints.md, assumptions.md, risks.md)
    │
    ▼
Read phase handoff (if applicable)
    │
    ▼
Determine next action
(no interactive prompts)
```

### Resumption Scenarios

#### Scenario 1: Phase in_progress

```
Reading active-workflow.md...
Phase: design
Status: in_progress

Actions:
1. Read phase handoff from previous phase
2. Read canonical knowledge
3. Read current phase output (if exists)
4. Continue from last completed action
```

#### Scenario 2: Phase blocked (Debate)

```
Reading active-workflow.md...
Phase: brainstorm
Status: blocked
debate_status: pending
debate_id: brainstorm-20260127-143022

Actions:
1. Check debate directory for completion
2. If synthesis.md exists: extract decisions, unblock phase
3. If incomplete: remain blocked, report status
```

#### Scenario 3: Phase completed

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

### State File Format

`.claude/forge/active-workflow.md`:
```yaml
---
# Identity
phase: brainstorm
workflow: forge-brainstorm
version: "2.0"

# Status
phase_status: in_progress          # pending | in_progress | blocked | completed
started_at: 2026-01-27T10:00:00Z
last_updated: 2026-01-27T14:30:00Z
completed_at: null

# Debate State
debate_id: brainstorm-20260127-143022
debate_status: pending             # none | pending | complete

# Progress
completed_tasks:
  - task-01-explore-options
  - task-02-generate-debate-plan
pending_tasks:
  - task-03-wait-debate-completion
  - task-04-synthesize-decision
blocked_tasks: []

# Context
context:
  feature: "user-authentication"
  branch: "feat/auth"
  related_docs:
    - docs/forge/brainstorm-options.md
    - docs/forge/debate/brainstorm-20260127-143022/debate-plan.md

# Metadata
metadata:
  estimated_hours: 4
  actual_hours: 2.5
  risk_level: medium
  priority: high
---
```

---

## Commands

### Workflow Commands (10-Phase)

| Command | Phase | Purpose |
|---------|-------|---------|
| `/forge:start` | 0. Init | Personalize FORGE for the project |
| `/forge:brainstorm` | 1. Brainstorm | Explore approaches with mandatory debate |
| `/forge:research` | 2. Research | Validate decisions with best practices |
| `/forge:design` | 3. Design | Create design specifications |
| `/forge:plan` | 4. Plan | Detailed implementation planning |
| `/forge:test` | 5. Test | Test strategy and ATDD |
| `/forge:build` | 6. Build | Execute with TDD discipline |
| `/forge:validate` | 7. Validate | Verify against requirements |
| `/forge:review` | 8. Review | Code review from multiple angles |
| `/forge:learn` | 9. Learn | Capture knowledge and patterns |

### Utility Commands

| Command | Purpose |
|---------|---------|
| `/forge:continue` | Resume from saved state (file-based recovery) |
| `/forge:status` | Show workflow state |
| `/forge:debate` | Manage debate lifecycle (generate plan, check status) |
| `/forge:quick` | Quick task execution (bypass full workflow) |
| `/forge:help` | Show workflow help |

### Debate Commands

| Command | Purpose |
|---------|---------|
| `/forge:debate --status --id <id>` | Check debate completion |
| `/forge:debate --plan --phase <phase> --topic "<topic>"` | Generate debate plan |
| `/forge:debate --regenerate --id <id>` | Regenerate debate plan |

---

## Quick Start Guide

### 1. Initialize FORGE

```bash
/forge:start "Build a user authentication system"
```

FORGE will:
- Detect project type
- Create configuration
- Set up directory structure
- Create project brief

### 2. Brainstorm with Debate

```bash
/forge:brainstorm
```

FORGE will:
- Generate 3+ approach options
- Create debate plan
- Output AO spawn commands
- Block until debate completes

### 3. Execute Debate (via AO)

AO spawns debate sessions:
```bash
ao spawn my-project "FORGE: Write advocate.md for debate brainstorm-20260127-143022"
ao spawn my-project "FORGE: Write skeptic.md for debate brainstorm-20260127-143022"
ao spawn my-project "FORGE: Write operator.md for debate brainstorm-20260127-143022"
ao spawn my-project "FORGE: Write synthesis.md for debate brainstorm-20260127-143022"
```

### 4. Continue After Debate

```bash
/forge:continue
```

FORGE will:
- Detect debate completion
- Extract decisions and risks
- Complete brainstorm phase
- Proceed to research

### 5. Progress Through Phases

```bash
/forge:research    # Validate decisions
/forge:design      # Create specifications
/forge:plan        # Plan implementation
/forge:test        # Define test strategy
/forge:build       # Execute with TDD
/forge:validate    # Verify requirements
/forge:review      # Code review
/forge:learn       # Capture patterns
```

### 6. Resume Anytime

If interrupted, simply:
```bash
/forge:continue
```

---

## Agents

### Core Agents

| Agent | Purpose | Trigger |
|-------|---------|---------|
| `@skill-router` | Route tasks to skills | Session start |
| `@builder` | TDD implementation | Build phase |
| `@researcher` | Best practices research | Research phase |
| `@security-reviewer` | Security audit | Review phase |
| `@performance-guardian` | Performance optimization | Optimization requests |
| `@brainstormer` | Ideation and exploration | Brainstorm phase |
| `@mass-change` | Large-scale refactoring | Mass change requests |
| `@docs-maintainer` | Documentation maintenance | Doc drift |

### Debate Role Agents (AO-Spawned)

| Agent | Role | Output |
|-------|------|--------|
| `@advocate` | Argues FOR the approach | `advocate.md` |
| `@skeptic` | Probes weaknesses | `skeptic.md` |
| `@operator` | Assesses feasibility | `operator.md` |
| `@synthesizer` | Produces final decision | `synthesis.md` |

---

## Skills

### Core Skills

- `@forge-init` - Initialize FORGE
- `@forge-context` - Load workflow context
- `@forge-memory` - Memory management
- `@forge-config` - Configuration management
- `@state-tracking` - Workflow state tracking

### Workflow Skills

- `@forge-brainstorm` - Brainstorm phase with debate
- `@forge-research` - Research phase
- `@forge-design` - Design phase
- `@forge-plan` - Plan phase
- `@forge-test` - Test phase
- `@forge-build` - Build phase
- `@forge-validate` - Validate phase
- `@forge-review` - Review phase
- `@forge-learn` - Learn phase

### Quality Skills

- `@atdd-workflow` - Acceptance Test Driven Development
- `@risk-based-testing` - Risk-based test strategy
- `@test-automation` - Test automation patterns
- `@test-review` - Test review guidelines
- `@ci-cd-setup` - CI/CD pipeline setup

---

## Configuration

### Environment Variables

| Variable | Purpose | Required |
|----------|---------|----------|
| `AO_SESSION` | AO session ID | Yes |
| `AO_DATA_DIR` | AO metadata directory | Yes |
| `AO_SESSION_NAME` | Human-readable session name | No |
| `AO_ISSUE_ID` | Associated issue ID | No |
| `FORGE_ARTIFACT_LEVEL` | minimal \| intelligent \| maximal | No |

### Settings File

`.claude/forge/config.json`:
```json
{
  "project_type": "react",
  "initialized": "2026-01-27",
  "artifact_level": "intelligent",
  "phases": {
    "completed": ["brainstorm", "research"],
    "current": "design",
    "pending": ["plan", "test", "build", "validate", "review", "learn"]
  },
  "preferences": {
    "karpathy_enforced": true,
    "security_checks": true,
    "auto_lint": true,
    "debate_required": true
  }
}
```

---

## Installation

### For AO Projects

Add to your `agent-orchestrator.yaml`:

```yaml
projects:
  - name: my-project
    postCreate:
      - "node .claude/plugins/forge-ao/integrations/agent-orchestrator/install.mjs --workspace ."
    agentConfig:
      systemPromptFile: ".claude/forge/forge-system-prompt.md"
```

### Manual Installation

```bash
cd your-project
node /path/to/forge-ao/integrations/agent-orchestrator/install.mjs --workspace .
```

---

## Testing

Run the smoke test:

```bash
# Manual test
/forge:start "smoke test"
/forge:brainstorm
/forge:debate --status --id <id>
/forge:continue

# Or see full test specification
cat docs/forge/SMOKE-TEST.md
```

---

## Documentation

- [Smoke Test](docs/forge/SMOKE-TEST.md) - Verification test suite
- [Architecture](docs/forge/ARCHITECTURE.md) - AO-native design details
- [Debate Schema](docs/debate-schema.md) - Debate gate specification
- [Action Checklist](docs/action-checklist.md) - Implementation checklist

---

## License

MIT

---

*FORGE-AO Version 2.0.0 - AO-native, file-driven, debate-gated development workflow*
