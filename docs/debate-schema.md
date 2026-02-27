# FORGE Debate Schema v2.0 (AO-Native)

## Overview

The Debate Gate is a mandatory checkpoint that ensures structured evaluation of options before commitment. In AO-native FORGE, debate is entirely artifact-driven.

## Core Principle

**FORGE generates debate plans. AO executes debate via role sessions. Completion is detected via file existence.**

## Debate Directory Structure

```
docs/forge/debate/
└── <phase>-<timestamp>/          # e.g., brainstorm-20260115-143022
    ├── debate-plan.md            # FORGE generates this
    ├── advocate.md               # AO-spawned advocate writes this
    ├── skeptic.md                # AO-spawned skeptic writes this
    ├── operator.md               # AO-spawned operator writes this
    └── synthesis.md              # AO-spawned synthesizer writes this
```

## Debate Lifecycle (AO-Native)

### Phase 1: FORGE Generates Debate Plan

FORGE creates `debate-plan.md` with:
- Clear objective statement
- Options under consideration
- Role definitions and prompts for each role
- Expected outputs
- Completion criteria

### Phase 2: AO Spawns Role Sessions

FORGE outputs AO spawn commands (not executed, provided as plan):

```
ao spawn <project> "debate-role: advocate --debate-id=<id> --plan=debate-plan.md"
ao spawn <project> "debate-role: skeptic --debate-id=<id> --plan=debate-plan.md"
ao spawn <project> "debate-role: operator --debate-id=<id> --plan=debate-plan.md"
ao spawn <project> "debate-role: synthesizer --debate-id=<id> --plan=debate-plan.md"
```

### Phase 3: Role Sessions Execute in Parallel

Each AO-spawned role:
1. Reads `debate-plan.md`
2. Writes its assigned output file
3. Exits

### Phase 4: FORGE Detects Completion

FORGE checks for file existence:
- All role files exist and are non-empty
- `synthesis.md` contains required sections

### Phase 5: FORGE Finalizes Phase

- Extracts decisions from synthesis.md
- Writes to `docs/forge/knowledge/decisions.md`
- Updates `docs/forge/knowledge/risks.md`
- Updates workflow state
- Proceeds to next phase

## Required Files

### 1. debate-plan.md (FORGE generates)

```yaml
---
debate_id: "brainstorm-20260115-143022"
phase: "brainstorm"
objective: "Clear statement of decision to be made"
status: "pending|running|complete"
---
```

**Required Sections:**
- `Objective` - Clear statement of decision to be made
- `Options Under Consideration` - List of 3+ approaches
- `Role Prompts` - Specific instructions for each AO-spawned role
- `Expected Outputs` - List of files each role must produce
- `Completion Criteria` - How FORGE will detect completion

### 2. advocate.md (AO-spawned advocate writes)

**Required Sections:**
- `Core Argument` - 3 sentences max
- `Key Strengths` - Bullet list with evidence
- `Comparative Advantages` - vs other options
- `Success Criteria` - Measurable outcomes
- `Risk Acceptance` - Risks deemed acceptable

### 3. skeptic.md (AO-spawned skeptic writes)

**Required Sections:**
- `Critical Questions` - 5+ probing questions
- `Hidden Assumptions` - Unstated beliefs
- `Failure Modes` - How it could go wrong
- `Risk Analysis` - Probability × Impact matrix
- `Second-Order Effects` - Consequences of consequences

### 4. operator.md (AO-spawned operator writes)

**Required Sections:**
- `Resource Requirements` - Time, cost, dependencies
- `Timeline Reality Check` - Optimistic/Realistic/Pessimistic
- `Dependency Analysis` - What must happen first
- `Operational Constraints` - Maintenance, monitoring
- `Go/No-Go Recommendation` - Feasibility verdict

### 5. synthesis.md (AO-spawned synthesizer writes)

**Required Sections:**
- `Debate Summary` - Positions from all roles
- `Key Tradeoffs` - What we gain vs give up
- `Final Decision` - Clear choice with rationale
- `Decision Criteria` - Weights and scoring
- `Kill-Switch Criteria` - When to abort
- `Fallback Plan` - What if primary fails
- `Risks Accepted` - Table with owners
- `Action Items` - Who does what by when

## Debate Gate Completion Criteria

A debate gate **PASSES** when:

```yaml
all_files_exist: true
all_files_non_empty: true
synthesis_includes:
  - final_decision
  - decision_criteria
  - kill_switch_criteria
  - fallback_plan
  - action_items
```

A debate gate **BLOCKS** when:

```yaml
any_file_missing: true
synthesis_incomplete: true
decision_unclear: true
```

**FORGE behavior on block:**
- Phase cannot complete
- Workflow state shows "blocked on debate"
- /forge:continue will re-check debate completion

## Kill-Switch Criteria Format

Each synthesis must include explicit kill-switch criteria:

```markdown
## Kill-Switch Criteria

**We will ABORT and reconsider if:**

- [Condition]: [Specific, measurable threshold]
  - Detection: [How we'll monitor]
  - Timeline: [When to check]
  - Fallback: [What to do instead]
```

## Debate Metadata

Debate state is tracked in:
- File: `.claude/forge/active-workflow.md`
- Fields:
  - `debate_id` - Unique identifier
  - `debate_phase` - Which phase owns the debate
  - `debate_status` - pending|running|complete
  - `debate_gate_passed` - true|false

## Debate Configuration

Debate behavior is controlled via `debate_config` in `workflows/forge-workflow.json`.

### Configuration Options

```yaml
debate_config:
  default_trigger: "major_decision"  # always, major_decision, risk_threshold, never, explicit_only
  risk_threshold: 6                  # Minimum risk score to trigger debate
  component_threshold: 3             # Component count to trigger "major decision"
```

### Trigger Modes

| Mode | Description |
|------|-------------|
| `always` | Debate runs for every phase that has it enabled |
| `major_decision` | Debate triggers when >3 components affected or decision challenges prior decision |
| `risk_threshold` | Debate triggers when risk score ≥ configured threshold |
| `never` | Debate never runs automatically (can still be forced via CLI) |
| `explicit_only` | Debate only runs when explicitly requested via `--debate` flag |

### CLI Flags

All phases support debate control via CLI flags:

```bash
# Force debate even if not triggered by configuration
/forge:brainstorm "objective" --debate
/forge:design "objective" --debate
/forge:plan "objective" --debate

# Skip debate even if triggered by configuration
/forge:brainstorm "objective" --no-debate
```

### Per-Phase Debate Settings

Each phase can override the default trigger:

```yaml
phases:
  - id: brainstorm
    debate_enabled: true
    debate_trigger: "always"  # Override default_trigger
  - id: design
    debate_enabled: true
    debate_trigger: "major_decision"
  - id: plan
    debate_enabled: false     # Disable debate for this phase
```

### Flag Override Logic

Debate execution is determined by:

1. **Explicit `--debate` flag**: Forces debate ON (highest priority)
2. **Explicit `--no-debate` flag**: Forces debate OFF
3. **Phase configuration**: `debate_enabled` and `debate_trigger` settings
4. **Default configuration**: `debate_config.default_trigger` (lowest priority)

## Debate Triggers

Debate is mandatory when:
1. **Brainstorm phase** - Always requires debate (unless `--no-debate` override)
2. **Major decision** - Any decision affecting >3 components
3. **Prior decision challenged** - New information invalidates prior decision
4. **Risk exceeds tolerance** - Risk score ≥ 6 (High×Medium or higher)

## AO Role Agent Definitions

These agents are spawned by AO, not by FORGE:

### @advocate
- **Writes to:** `docs/forge/debate/<id>/advocate.md`
- **Receives:** `debate-plan.md`, relevant context
- **Output format:** Structured argument FOR the approach

### @skeptic
- **Writes to:** `docs/forge/debate/<id>/skeptic.md`
- **Receives:** `debate-plan.md`, relevant context
- **Output format:** Critical analysis and concerns

### @operator
- **Writes to:** `docs/forge/debate/<id>/operator.md`
- **Receives:** `debate-plan.md`, relevant context
- **Output format:** Feasibility assessment

### @synthesizer
- **Writes to:** `docs/forge/debate/<id>/synthesis.md`
- **Receives:** `debate-plan.md`, advocate.md, skeptic.md, operator.md
- **Output format:** Final decision with rationale

## Commands

```bash
# Check debate status (reads files, reports completion)
/forge:debate --status --id <debate-id>

# Regenerate debate plan (if requirements changed)
/forge:debate --regenerate --id <debate-id>
```

## Version History

- v2.0 - AO-native design, removed standalone mode
- v1.0 - Initial debate schema
