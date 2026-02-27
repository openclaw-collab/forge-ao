# FORGE Debate Schema v1.0

## Overview

The Debate Gate is a mandatory checkpoint within the Brainstorm phase (and optionally other phases) that ensures structured evaluation of options before commitment.

## Debate Directory Structure

```
docs/forge/debate/
└── <phase>-<timestamp>/          # e.g., brainstorm-20260115-143022
    ├── debate-plan.md            # Debate structure and role prompts
    ├── advocate.md               # Case FOR the leading option
    ├── skeptic.md                # Concerns and risk analysis
    ├── operator.md               # Implementation feasibility
    └── synthesis.md              # Final decision with criteria
```

## Required Files

### 1. debate-plan.md

**Purpose:** Defines the debate structure, roles, and rules.

**Required Sections:**
- `Objective` - Clear statement of decision to be made
- `Options Under Consideration` - List of 3+ approaches
- `Debate Structure` - Role definitions
- `Debate Rules` - Constraints and requirements
- `Expected Outputs` - List of files to produce

### 2. advocate.md

**Purpose:** Makes the strongest case FOR an option.

**Required Sections:**
- `Core Argument` - 3 sentences max
- `Key Strengths` - Bullet list with evidence
- `Comparative Advantages` - vs other options
- `Success Criteria` - Measurable outcomes
- `Risk Acceptance` - Risks deemed acceptable

### 3. skeptic.md

**Purpose:** Probes weaknesses and challenges assumptions.

**Required Sections:**
- `Critical Questions` - 5+ probing questions
- `Hidden Assumptions` - Unstated beliefs
- `Failure Modes` - How it could go wrong
- `Risk Analysis` - Probability × Impact matrix
- `Second-Order Effects` - Consequences of consequences

### 4. operator.md

**Purpose:** Assesses implementation reality.

**Required Sections:**
- `Resource Requirements` - Time, cost, dependencies
- `Timeline Reality Check` - Optimistic/Realistic/Pessimistic
- `Dependency Analysis` - What must happen first
- `Operational Constraints` - Maintenance, monitoring
- `Go/No-Go Recommendation` - Feasibility verdict

### 5. synthesis.md

**Purpose:** Reconciles positions and produces decision.

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

A debate gate **FAILS** when:

```yaml
any_file_missing: true
synthesis_incomplete: true
decision_unclear: true
```

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

## AO Integration

When running under AO:

1. FORGE generates `debate-plan.md` only
2. FORGE outputs AO spawn commands
3. AO spawns role sessions (advocate, skeptic, operator, synthesizer)
4. Each role writes its assigned file
5. FORGE detects completion via file existence
6. FORGE finalizes phase after synthesis exists

## Standalone Mode

When running standalone:

1. FORGE generates `debate-plan.md`
2. FORGE runs each role sequentially in session
3. Each role writes its file
4. FORGE checks completion
5. FORGE finalizes phase

## Templates

Role templates are located at:
- `templates/debate/advocate.md`
- `templates/debate/skeptic.md`
- `templates/debate/operator.md`
- `templates/debate/synthesis.md`

## Commands

```bash
# Initialize debate
/forge:debate --init --phase brainstorm

# Check status
/forge:debate --status --id <debate-id>

# Generate AO plan
/forge:debate --plan --id <debate-id>

# Run standalone
/forge:debate --run --id <debate-id>

# Check completion
/forge:debate --check --id <debate-id>
```

## Version History

- v1.0 - Initial debate schema with 4 roles and mandatory synthesis
