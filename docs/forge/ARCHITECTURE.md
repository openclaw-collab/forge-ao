# FORGE-AO Architecture

**AO-Native Design Specification - Version 2.0.0**

---

## Table of Contents

1. [AO-Native Design Philosophy](#ao-native-design-philosophy)
2. [How FORGE Behaves Under AO](#how-forge-behaves-under-ao)
3. [File-Based State Management](#file-based-state-management)
4. [Phase Boundaries and Handoffs](#phase-boundaries-and-handoffs)
5. [Debate Gate Mechanics](#debate-gate-mechanics)

---

## AO-Native Design Philosophy

### Core Principle: Files Are Source of Truth

FORGE-AO 2.0 is designed exclusively for Agent Orchestrator (AO) environments. Unlike traditional workflow systems that rely on in-memory state or chat context, FORGE treats the filesystem as the single source of truth.

```
Traditional Workflow:          FORGE-AO:
┌─────────────┐               ┌─────────────┐
│ Chat State  │               │ File State  │
│ (ephemeral) │               │ (persistent)│
└─────────────┘               └─────────────┘
       │                             │
       ▼                             ▼
  Lost on crash               Survives anything
  Context-dependent           Context-independent
  Hard to resume              Always resumable
```

### Design Tenets

1. **Deterministic Recovery**
   - Any session can resume from any point
   - No "memory" of previous conversations required
   - State is fully reconstructible from files

2. **AO Session Spawning**
   - FORGE never spawns subagents internally
   - AO manages all parallel execution
   - FORGE detects completion via file existence

3. **Explicit Phase Gates**
   - Phases cannot complete without required artifacts
   - Debate gates are blocking by design
   - Handoff documents lock decisions

4. **Non-Interactive Operation**
   - No prompts during `/forge:continue`
   - Decisions encoded in files
   - Deterministic behavior given same file state

---

## How FORGE Behaves Under AO

### Environment Detection

FORGE detects AO mode via environment variables:

```javascript
// AO mode active when:
const isAOMode = process.env.AO_SESSION && process.env.AO_DATA_DIR;
```

| Variable | Purpose | Required |
|----------|---------|----------|
| `AO_SESSION` | Unique session identifier | Yes |
| `AO_DATA_DIR` | Path to AO metadata | Yes |
| `AO_SESSION_NAME` | Human-readable name | No |
| `AO_ISSUE_ID` | Associated issue tracker ID | No |

### Behavioral Differences

| Aspect | Standalone Mode | AO Mode (FORGE 2.0) |
|--------|-----------------|---------------------|
| **Subagent Spawning** | Internal spawning | Never spawns - AO handles |
| **Debate Execution** | Sequential self-debate | AO spawns parallel roles |
| **State Storage** | Memory + files | Files only |
| **Metadata Sync** | None | Automatic AO sync |
| **Resume Method** | Session restore | `/forge:continue` |
| **Hook Location** | Plugin directory | Workspace `.claude/` |

### AO Metadata Sync

When running under AO, FORGE automatically syncs these keys:

```yaml
# Synced to AO metadata
forge_phase: "brainstorm"           # Current phase
forge_status: "in_progress"         # Workflow status
forge_next: "research"              # Next phase
forge_summary: "Exploring auth..."  # Brief summary
forge_debate_id: "brainstorm-..."   # Active debate ID
forge_debate_status: "pending"      # Debate status
forge_branch: "feat/auth"           # Git branch
forge_issue: "PROJ-123"             # Related issue
forge_version: "2.0.0"              # Workflow version
forge_started_at: "2026-01-27..."   # Start timestamp
forge_last_updated: "2026-01-27..." # Last update
```

### FORGE Responsibilities in AO Mode

```
┌─────────────────────────────────────────────────────────────┐
│                      FORGE Responsibilities                  │
├─────────────────────────────────────────────────────────────┤
│ 1. Generate debate plans (debate-plan.md)                   │
│ 2. Output AO spawn commands (for reference)                 │
│ 3. Check debate completion via file existence               │
│ 4. Extract decisions from synthesis.md                      │
│ 5. Manage phase transitions                                 │
│ 6. Maintain active-workflow.md                              │
│ 7. Sync metadata to AO                                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                        AO Responsibilities                   │
├─────────────────────────────────────────────────────────────┤
│ 1. Spawn role sessions (advocate, skeptic, etc.)            │
│ 2. Execute debate in parallel                               │
│ 3. Each role writes assigned file                           │
│ 4. Manage session lifecycle                                 │
│ 5. Provide AO_SESSION, AO_DATA_DIR                          │
└─────────────────────────────────────────────────────────────┘
```

---

## File-Based State Management

### State Hierarchy

```
State Sources (highest to lowest priority):

1. .claude/forge/active-workflow.md
   └── Primary source of truth for current workflow

2. docs/forge/knowledge/*.md
   └── decisions.md, constraints.md, assumptions.md, risks.md

3. docs/forge/handoffs/*.md
   └── Phase-to-phase handoff documents

4. docs/forge/debate/<id>/*.md
   └── Debate artifacts

5. docs/forge/phases/*.md
   └── Phase working documents

6. .claude/forge/config.json
   └── Project configuration
```

### active-workflow.md Format

This file is the heartbeat of FORGE state:

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
current_task: task-03-wait-debate-completion

# Context
context:
  feature: "user-authentication"
  branch: "feat/auth"
  related_docs:
    - docs/forge/brainstorm-options.md
    - docs/forge/debate/brainstorm-20260127-143022/debate-plan.md
  decisions:
    - "D1: Use JWT for authentication"
  assumptions:
    - "A1: OAuth2 provider available"

# Metadata
metadata:
  estimated_hours: 4
  actual_hours: 2.5
  risk_level: medium
  priority: high
  karpathy_score: 4.5
---

# Workflow Notes (free-form below frontmatter)

## Current Focus
Waiting for debate completion before proceeding.

## Blockers
None - debate in progress.

## Next Actions
1. Monitor debate directory for synthesis.md
2. Extract decisions when complete
3. Generate phase handoff
```

### State Recovery Algorithm

When `/forge:continue` is invoked:

```python
def resume_workflow():
    # Step 1: Read primary state
    state = read_yaml_frontmatter(".claude/forge/active-workflow.md")

    # Step 2: Load canonical knowledge
    knowledge = {
        "decisions": read("docs/forge/knowledge/decisions.md"),
        "constraints": read("docs/forge/knowledge/constraints.md"),
        "assumptions": read("docs/forge/knowledge/assumptions.md"),
        "risks": read("docs/forge/knowledge/risks.md")
    }

    # Step 3: Read phase handoff (if not first phase)
    if state.phase != "init":
        prev_phase = get_previous_phase(state.phase)
        handoff = read(f"docs/forge/handoffs/{prev_phase}-to-{state.phase}.md")

    # Step 4: Read current phase output
    phase_output = read(f"docs/forge/phases/{state.phase}.md")

    # Step 5: Determine action based on status
    if state.phase_status == "blocked":
        if state.debate_status == "pending":
            check_debate_completion(state.debate_id)
    elif state.phase_status == "in_progress":
        continue_from_task(state.current_task)
    elif state.phase_status == "completed":
        prepare_next_phase(state.next_phase)

    # No interactive prompts - purely file-driven
```

### Snapshot and Archive

**Session Snapshots:**
- Location: `.claude/forge/snapshots/YYYYMMDD-HHMMSS.md`
- Triggered: On phase transition, hourly, manual `/forge:save`
- Purpose: Recovery points for corruption

**Archive:**
- Location: `.claude/forge/archive/workflow-<id>.md`
- Triggered: On workflow completion
- Purpose: Historical record, pattern mining

---

## Phase Boundaries and Handoffs

### Phase Lifecycle

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│  ENTER   │───▶│ EXECUTE  │───▶│  GATE    │───▶│  EXIT    │
│  PHASE   │    │  WORK    │    │  CHECK   │    │  PHASE   │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
     │               │               │               │
     ▼               ▼               ▼               ▼
Read handoff    Do work         Debate gate     Write handoff
from previous   Update state    (if required)   to next phase
```

### Entry Protocol

Every phase follows this entry sequence:

```markdown
## Phase Entry: [Phase Name]

### 1. Read Previous Handoff
- Load: `docs/forge/handoffs/<prev>-to-<current>.md`
- Extract: Locked decisions, open assumptions, TODO list

### 2. Load Canonical Knowledge
- decisions.md (locked decisions)
- constraints.md (hard constraints)
- assumptions.md (open assumptions)
- risks.md (known risks)

### 3. Initialize Phase State
- Update active-workflow.md
- Set phase_status: "in_progress"
- Create phase working document

### 4. Display Context Summary
- Show locked decisions
- List constraints
- Highlight open assumptions
- Present TODO list
```

### Exit Protocol

Every phase follows this exit sequence:

```markdown
## Phase Exit: [Phase Name]

### 1. Validate Completion
- [ ] All TODO items complete
- [ ] Required artifacts exist
- [ ] Debate gate passed (if applicable)

### 2. Extract Knowledge
- Decisions → decisions.md
- New constraints → constraints.md
- Validated/invalidated assumptions → assumptions.md
- Risks → risks.md

### 3. Create Handoff Document
- Write: `docs/forge/handoffs/<current>-to-<next>.md`
- Include: Locked decisions, constraints, TODO for next phase

### 4. Update State
- phase_status: "completed"
- completed_at: [timestamp]
- next_phase: [next phase name]

### 5. Archive Phase Document
- Move working doc to `docs/forge/phases/`
- Create final artifact in `docs/forge/`
```

### Handoff Document Format

```yaml
---
from_phase: "brainstorm"
to_phase: "research"
generated_at: "2026-01-27T15:00:00Z"
workflow_id: "forge-20260127-143022"
status: "final"
---

# Phase Handoff: Brainstorm → Research

## Summary

### What Was Done
Explored 3 authentication approaches and selected JWT-based solution through structured debate.

### Key Outcomes
- Selected: JWT with refresh tokens
- Confidence: High
- Debate ID: brainstorm-20260127-143022

### Time Spent
2.5 hours

## Locked Decisions

| Decision ID | Title | Rationale | Challenge Requires Debate |
|-------------|-------|-----------|---------------------------|
| D1 | Use JWT for auth | Scalable, stateless | Yes |
| D2 | Refresh token rotation | Security best practice | No |

## Open Assumptions

| Assumption ID | Description | Validation Due By | Risk if Invalid |
|---------------|-------------|-------------------|-----------------|
| A1 | OAuth2 provider available | Research phase | High - blocks implementation |
| A2 | Team knows JWT | Research phase | Low - training available |

## Constraints for Next Phase

| Constraint ID | Description | Source | Violation Triggers |
|---------------|-------------|--------|--------------------|
| C1 | Must use existing auth provider | D1 | Reopen debate |
| C2 | Token expiry ≤ 24 hours | Security policy | Security review |

## TODO List for Research Phase

1. [ ] Validate OAuth2 provider capabilities
2. [ ] Research JWT libraries for our stack
3. [ ] Verify refresh token rotation patterns
4. [ ] Document security considerations

## Escalation Conditions

Conditions that require debate before proceeding:

- [ ] OAuth2 provider doesn't support required flows
- [ ] JWT libraries have critical vulnerabilities
- [ ] Performance requirements exceed JWT capabilities

## Risk Summary

| Risk Level | Count | Highest Priority Risk |
|------------|-------|----------------------|
| High       | 1     | OAuth2 provider unavailable |
| Medium     | 2     | Token refresh complexity |
| Low        | 1     | Team learning curve |

## Artifacts Produced

| Artifact | Location | Status |
|----------|----------|--------|
| Brainstorm Options | docs/forge/brainstorm-options.md | Complete |
| Debate Synthesis | docs/forge/debate/brainstorm-*/synthesis.md | Complete |
| Brainstorm Final | docs/forge/brainstorm.md | Complete |

## Reference Materials

- Phase output: `docs/forge/phases/brainstorm.md`
- Decisions: `docs/forge/knowledge/decisions.md`
- Assumptions: `docs/forge/knowledge/assumptions.md`
- Risks: `docs/forge/knowledge/risks.md`

## Sign-off

Phase completed: Yes
Blocked by: None
Ready to proceed: Yes
```

---

## Debate Gate Mechanics

### Debate as a Blocking Gate

The Debate Gate is a mandatory checkpoint that prevents phase completion until structured evaluation is complete.

```
Phase Execution Flow:

┌─────────────────┐
│   Phase Work    │
│   (exploration) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Generate Plan  │◄── FORGE creates debate-plan.md
│  (debate-plan)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌─────────────────┐
│   BLOCKED ON    │◄────│  AO spawns      │
│     DEBATE      │     │  role sessions  │
│  (waiting for   │     │  (parallel)     │
│    synthesis)   │     │                 │
└────────┬────────┘     └─────────────────┘
         │
         │ Files created:
         │ ✓ advocate.md
         │ ✓ skeptic.md
         │ ✓ operator.md
         │ ✓ synthesis.md
         ▼
┌─────────────────┐
│   GATE PASSES   │◄── FORGE detects completion
│  (unblock phase)│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Complete Phase  │
│ (extract decis) │
└─────────────────┘
```

### Debate Directory Structure

```
docs/forge/debate/
└── brainstorm-20260127-143022/          # Unique debate ID
    ├── debate-plan.md                   # FORGE generates
    │   └── Contains: objective, options, role prompts, criteria
    ├── advocate.md                      # AO-spawned advocate
    │   └── Contains: case FOR the approach
    ├── skeptic.md                       # AO-spawned skeptic
    │   └── Contains: concerns, failure modes
    ├── operator.md                      # AO-spawned operator
    │   └── Contains: feasibility assessment
    └── synthesis.md                     # AO-spawned synthesizer
        └── Contains: final decision, kill-switch, fallback
```

### Gate Pass Criteria

A debate gate **PASSES** when ALL of the following are true:

```yaml
file_check:
  debate-plan.md:
    exists: true
    non_empty: true
  advocate.md:
    exists: true
    non_empty: true
  skeptic.md:
    exists: true
    non_empty: true
  operator.md:
    exists: true
    non_empty: true
  synthesis.md:
    exists: true
    non_empty: true
    contains_sections:
      - "Final Decision"
      - "Decision Criteria"
      - "Kill-Switch Criteria"
      - "Fallback Plan"
      - "Action Items"
```

### Gate Block Criteria

A debate gate **BLOCKS** when ANY of the following are true:

```yaml
block_conditions:
  - any_debate_file_missing: true
  - synthesis_incomplete: true
  - decision_unclear: true
  - no_kill_switch_criteria: true
  - no_fallback_plan: true
```

### Debate State Machine

```
                    ┌─────────────┐
                    │   NONE      │
                    │ (no debate) │
                    └──────┬──────┘
                           │ /forge:brainstorm
                           │ (generates plan)
                           ▼
                    ┌─────────────┐
         ┌─────────│   PENDING   │◄────────┐
         │         │ (plan exists)│         │
         │         └──────┬──────┘         │
         │                │                │
         │                │ AO spawns      │
         │                │ roles          │
         │                ▼                │
   synthesis.md         ┌─────────────┐    │ debate
   incomplete          │   RUNNING   │────┘ incomplete
         │             │(files being │
         │             │   written)  │
         │             └──────┬──────┘
         │                    │
         │                    │ All files
         │                    │ complete
         │                    ▼
         │             ┌─────────────┐
         └────────────►│  COMPLETE   │
                       │(gate passes)│
                       └──────┬──────┘
                              │
                              │ FORGE extracts
                              │ decisions
                              ▼
                       ┌─────────────┐
                       │  UNBLOCKED  │
                       │(phase can   │
                       │  complete)  │
                       └─────────────┘
```

### Debate Completion Detection

FORGE checks debate status via file polling:

```javascript
function checkDebateCompletion(debateId) {
    const debateDir = `docs/forge/debate/${debateId}`;

    const requiredFiles = [
        'debate-plan.md',
        'advocate.md',
        'skeptic.md',
        'operator.md',
        'synthesis.md'
    ];

    // Check all files exist and are non-empty
    for (const file of requiredFiles) {
        const content = readFile(`${debateDir}/${file}`);
        if (!content || content.length < 100) {
            return { complete: false, missing: file };
        }
    }

    // Verify synthesis has required sections
    const synthesis = readFile(`${debateDir}/synthesis.md`);
    const requiredSections = [
        'Final Decision',
        'Kill-Switch Criteria',
        'Fallback Plan'
    ];

    for (const section of requiredSections) {
        if (!synthesis.includes(section)) {
            return { complete: false, incomplete_section: section };
        }
    }

    return { complete: true };
}
```

### Post-Debate Actions

When debate completes:

1. **Extract Decisions**
   - Parse synthesis.md for decisions
   - Append to decisions.md with metadata
   - Assign decision IDs

2. **Extract Risks**
   - Parse synthesis.md for risks table
   - Append to risks.md
   - Assign risk owners

3. **Update Constraints**
   - Convert decisions to constraints
   - Document in constraints.md
   - Mark as "locked by debate"

4. **Unblock Phase**
   - Update active-workflow.md
   - Set debate_status: "complete"
   - Set phase_status: "in_progress" (or proceed to complete)

5. **Create Phase Output**
   - Generate final phase document
   - Include debate reference
   - Document decision rationale

---

## Summary

FORGE-AO 2.0's architecture is built on these foundations:

1. **Files over Memory** - All state in version-controlled files
2. **AO over Internal** - AO spawns sessions; FORGE manages files
3. **Explicit over Implicit** - All gates and transitions are explicit
4. **Resumable over Continuous** - Any point can be resumed
5. **Deterministic over Adaptive** - Same files produce same behavior

This design ensures:
- **Reliability** - No lost work due to crashes
- **Transparency** - All decisions documented and reviewable
- **Scalability** - AO handles parallel execution
- **Auditability** - Complete history in git-trackable files

---

*FORGE-AO Architecture Specification v2.0.0*
