---
name: forge:brainstorm
description: Explore approaches through structured analysis with mandatory debate gate (AO-native)
disable-model-invocation: true
---

# /forge:brainstorm

Explore ideas and approaches through structured analysis with mandatory **Debate Gate**. This is an AO-native command - it operates exclusively within the AO ecosystem and blocks until debate synthesis is complete.

## AO-Native Behavior

- **No standalone mode** - AO-only execution
- **Mandatory debate gate** - Phase cannot complete without debate synthesis
- **Non-interactive** - No prompts, no menus, file-based state only
- **Blocking** - Waits for debate completion via file detection

---

## Phase Entry Protocol

### Step 1: Read Prerequisites

```bash
# Read these files before execution:
cat docs/forge/knowledge/decisions.md
cat docs/forge/knowledge/constraints.md
cat docs/forge/handoffs/init-to-brainstorm.md
```

### Step 2: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: brainstorm
phase_status: in_progress
phase_started_at: "<ISO-timestamp>"
completed_phases: []
active_debate_id: "brainstorm-<timestamp>"
---
```

---

## Phase Execution

### Step 1: Generate Exploration Document

Write exploration to `docs/forge/phases/brainstorm.md`:

```markdown
---
phase: brainstorm
generated_at: "<ISO-timestamp>"
objective: "<user-provided objective>"
status: exploring
---

# Brainstorm: [Objective]

## Context

### From Previous Phase
[Summary from init-to-brainstorm.md handoff]

### Constraints Applied
[List relevant constraints from constraints.md]

## Exploration

### Option A: [Name]
**Approach:** [Description]
**Pros:**
- ...
**Cons:**
- ...
**Complexity:** Low/Medium/High
**Estimated Effort:** [time]
**Confidence:** High/Medium/Low

### Option B: [Name]
...

### Option C: [Name]
...

## Preliminary Tradeoff Matrix

| Option | Simplicity | Performance | Maintainability | Risk |
|--------|------------|-------------|-----------------|------|
| A      | ★★★★★      | ★★★☆☆       | ★★★★☆           | Low  |
| B      | ...        | ...         | ...             | ...  |
| C      | ...        | ...         | ...             | ...  |

## Debate Trigger

**Debate Required:** Yes
**Debate ID:** brainstorm-<timestamp>
**Options for Debate:** A, B, C
**Key Tradeoffs:** [List the main tensions between options]
```

### Step 2: Generate Debate Plan

Create directory and write debate plan:

```bash
DEBATE_ID="brainstorm-$(date +%Y%m%d-%H%M%S)"
mkdir -p "docs/forge/debate/${DEBATE_ID}"
```

Write to `docs/forge/debate/{debate-id}/debate-plan.md`:

```markdown
---
debate_id: "brainstorm-<timestamp>"
phase: brainstorm
created_at: "<ISO-timestamp>"
status: pending
---

# Debate Plan: Brainstorm-[ID]

**Objective:** [Clear statement of what we're deciding]
**Context:** [Reference to brainstorm.md exploration]

## Options Under Consideration

1. **Option A:** [Name] - [One-line summary]
2. **Option B:** [Name] - [One-line summary]
3. **Option C:** [Name] - [One-line summary]

## Debate Structure

### Roles

**Advocate:** Argues FOR the leading option
- Strengths to emphasize
- Success criteria
- Comparative advantages

**Skeptic:** Argues AGAINST all options, probes weaknesses
- Risk analysis
- Hidden assumptions
- Failure modes

**Operator:** Assesses implementation feasibility
- Resource requirements
- Timeline realism
- Operational constraints

**Synthesizer:** Reconciles positions, produces decision
- Decision criteria weights
- Tradeoff resolution
- Final recommendation with rationale

## Debate Rules

1. Each role must produce written output
2. No role may contradict the core constraints
3. All risks raised must be addressed or accepted
4. Decision must include explicit kill-switch criteria

## Expected Outputs

- `advocate.md` - Case for the recommended approach
- `skeptic.md` - Concerns and risks
- `operator.md` - Feasibility assessment
- `synthesis.md` - Final decision with criteria

## AO Spawn Commands (Reference)

```bash
# These commands are for reference - AO spawns debate roles externally
# FORGE does not execute these

ao spawn <project> "FORGE: Write advocate.md for debate ${DEBATE_ID}"
ao spawn <project> "FORGE: Write skeptic.md for debate ${DEBATE_ID}"
ao spawn <project> "FORGE: Write operator.md for debate ${DEBATE_ID}"
ao spawn <project> "FORGE: Write synthesis.md for debate ${DEBATE_ID}"
```
```

### Step 3: Output AO Spawn Commands

Output the following for AO reference:

```
================================================================================
AO DEBATE SPAWN COMMANDS
================================================================================

Debate ID: ${DEBATE_ID}
Debate Plan: docs/forge/debate/${DEBATE_ID}/debate-plan.md

AO must spawn these sessions externally:

1. Advocate:
   ao spawn <project> "FORGE DEBATE: Write advocate.md for ${DEBATE_ID}. Read docs/forge/debate/${DEBATE_ID}/debate-plan.md and docs/forge/phases/brainstorm.md. Write your case to docs/forge/debate/${DEBATE_ID}/advocate.md"

2. Skeptic:
   ao spawn <project> "FORGE DEBATE: Write skeptic.md for ${DEBATE_ID}. Read docs/forge/debate/${DEBATE_ID}/debate-plan.md and docs/forge/phases/brainstorm.md. Write your critique to docs/forge/debate/${DEBATE_ID}/skeptic.md"

3. Operator:
   ao spawn <project> "FORGE DEBATE: Write operator.md for ${DEBATE_ID}. Read docs/forge/debate/${DEBATE_ID}/debate-plan.md and docs/forge/phases/brainstorm.md. Write feasibility assessment to docs/forge/debate/${DEBATE_ID}/operator.md"

4. Synthesizer:
   ao spawn <project> "FORGE DEBATE: Write synthesis.md for ${DEBATE_ID}. Read docs/forge/debate/${DEBATE_ID}/debate-plan.md, advocate.md, skeptic.md, and operator.md. Write final decision to docs/forge/debate/${DEBATE_ID}/synthesis.md"

================================================================================
BRAINSTORM PHASE BLOCKED - WAITING FOR DEBATE SYNTHESIS
================================================================================

Phase cannot continue until:
- docs/forge/debate/${DEBATE_ID}/advocate.md exists
- docs/forge/debate/${DEBATE_ID}/skeptic.md exists
- docs/forge/debate/${DEBATE_ID}/operator.md exists
- docs/forge/debate/${DEBATE_ID}/synthesis.md exists

FORGE will poll for file existence. Do not proceed until all files exist.
================================================================================
```

---

## Debate Gate (BLOCKING)

### Gate Condition

The brainstorm phase **CANNOT COMPLETE** until debate synthesis exists.

### Polling Mechanism

```bash
# Check every 30 seconds
while true; do
  if [[ -f "docs/forge/debate/${DEBATE_ID}/synthesis.md" ]]; then
    echo "Debate synthesis detected"
    break
  fi
  echo "Waiting for debate synthesis... ($(date))"
  sleep 30
done
```

### Required Files Checklist

Debate Gate passes when ALL files exist:

- [ ] `docs/forge/debate/{debate-id}/debate-plan.md`
- [ ] `docs/forge/debate/{debate-id}/advocate.md` (not empty)
- [ ] `docs/forge/debate/{debate-id}/skeptic.md` (not empty)
- [ ] `docs/forge/debate/{debate-id}/operator.md` (not empty)
- [ ] `docs/forge/debate/{debate-id}/synthesis.md` (with decision)

### On Debate Completion

When synthesis.md is detected:

1. **Extract decisions** and append to `docs/forge/knowledge/decisions.md`
2. **Extract/update risks** in `docs/forge/knowledge/risks.md`
3. **Generate final brainstorm artifact** (see below)

---

## Final Brainstorm Artifact

Read synthesis and write final `docs/forge/brainstorm.md`:

```markdown
---
phase: brainstorm
completed_at: "<ISO-timestamp>"
debate_id: "brainstorm-<timestamp>"
status: complete
---

# Brainstorm: [Objective]

## Decision Summary

**Selected Approach:** [Option X - Name]
**Confidence:** [High/Medium/Low]
**Decision Date:** [ISO timestamp]
**Debate Reference:** `docs/forge/debate/brainstorm-<timestamp>/`

## Decision Criteria

| Criterion | Weight | Option A | Option B | Option C |
|-----------|--------|----------|----------|----------|
| Simplicity| 30%    | 5/5      | 3/5      | 4/5      |
| Performance| 25%   | 3/5      | 5/5      | 4/5      |
| Maintainability| 25%| 4/5   | 3/5      | 5/5      |
| Risk      | 20%    | Low      | High     | Medium   |
| **Weighted Score** | | **4.25** | **3.55** | **4.45** |

## Why This Option Won

[2-3 sentence rationale tied to criteria from synthesis.md]

## Kill-Switch Criteria

**Revert to Option [Y] if:**
- [Specific condition 1]
- [Specific condition 2]
- [Measurable threshold exceeded]

## Fallback Plan

If primary approach fails:
1. [Fallback step 1]
2. [Fallback step 2]

## Risks Accepted

| Risk | Mitigation | Owner |
|------|------------|-------|
| [Risk 1] | [Mitigation] | [Who] |
| [Risk 2] | [Mitigation] | [Who] |

## Approaches Considered (Brief)

### Option A: [Name] (SELECTED)
[One-line description]

### Option B: [Name] (REJECTED)
[One-line description] - Rejected due to [reason from debate]

### Option C: [Name] (REJECTED)
[One-line description] - Rejected due to [reason from debate]

## Debate Artifacts

- Debate Plan: `docs/forge/debate/brainstorm-<timestamp>/debate-plan.md`
- Advocate: `docs/forge/debate/brainstorm-<timestamp>/advocate.md`
- Skeptic: `docs/forge/debate/brainstorm-<timestamp>/skeptic.md`
- Operator: `docs/forge/debate/brainstorm-<timestamp>/operator.md`
- Synthesis: `docs/forge/debate/brainstorm-<timestamp>/synthesis.md`

## Next Phase Input

**For Research:** Validate [specific aspect of selected approach]
**Key Questions:**
- [Question 1]
- [Question 2]
```

---

## Phase Exit Protocol

### Step 1: Write Handoff Document

Write to `docs/forge/handoffs/brainstorm-to-research.md`:

```markdown
---
from_phase: brainstorm
to_phase: research
generated_at: "<ISO-timestamp>"
workflow_id: "<workflow-id>"
status: final
---

# Phase Handoff: brainstorm → research

## Summary

### What Was Done
Explored 3+ approaches for "[objective]" and selected Option [X] via structured debate.

### Key Outcomes
- Selected approach: [Option X - Name]
- Confidence level: [High/Medium/Low]
- Debate artifacts: `docs/forge/debate/brainstorm-<timestamp>/`

## Locked Decisions

| Decision ID | Title | Rationale | Challenge Requires Debate |
|-------------|-------|-----------|---------------------------|
| D001 | [Selected approach] | [Brief rationale] | Yes |

## Open Assumptions

| Assumption ID | Description | Validation Due By | Risk if Invalid |
|---------------|-------------|-------------------|-----------------|
| A001 | [Assumption 1] | research phase | [Risk] |

## Constraints for Next Phase

| Constraint ID | Description | Source | Violation Triggers |
|---------------|-------------|--------|--------------------|
| C001 | [Constraint from decision] | brainstorm decision | Debate |

## TODO List for Next Phase

1. [ ] Validate [specific aspect] (priority: high)
2. [ ] Research [specific question]
3. [ ] Confirm [assumption]

## Escalation Conditions

- [ ] Selected approach proves infeasible during research
- [ ] New constraints discovered that conflict with decision

## Risk Summary

| Risk Level | Count | Highest Priority Risk |
|------------|-------|----------------------|
| High       | [N]   | [Risk description]   |
| Medium     | [N]   |                      |
| Low        | [N]   |                      |

## Artifacts Produced

| Artifact | Location | Status |
|----------|----------|--------|
| Exploration | docs/forge/phases/brainstorm.md | Complete |
| Debate Plan | docs/forge/debate/brainstorm-<timestamp>/debate-plan.md | Complete |
| Debate Synthesis | docs/forge/debate/brainstorm-<timestamp>/synthesis.md | Complete |
| Final Decision | docs/forge/brainstorm.md | Complete |

## Reference Materials

- Phase output: `docs/forge/phases/brainstorm.md`
- Decisions: `docs/forge/knowledge/decisions.md`
- Risks: `docs/forge/knowledge/risks.md`

## Sign-off

Phase completed: Yes
Blocked by: None
Ready to proceed: Yes
```

### Step 2: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: brainstorm
phase_status: completed
phase_started_at: "<ISO-timestamp>"
phase_completed_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
active_debate_id: null
next_phase: research
---
```

---

## Debate Role Prompts (For AO Spawn)

### Advocate System Prompt

```
You are the ADVOCATE in a structured FORGE debate.

Your job: Make the strongest possible case FOR the leading option.

Context:
- Read: docs/forge/debate/{debate-id}/debate-plan.md
- Read: docs/forge/phases/brainstorm.md
- Write to: docs/forge/debate/{debate-id}/advocate.md

Structure your output:
1. Core Argument (3 sentences max)
2. Key Strengths (bullet list)
3. Comparative Advantages (vs other options)
4. Success Criteria (how we'll know this worked)
5. Risk Acceptance (risks we're willing to take)

Rules:
- Be persuasive but honest
- Don't dismiss valid concerns
- Quantify benefits where possible
- Address the "best case" scenario
```

### Skeptic System Prompt

```
You are the SKEPTIC in a structured FORGE debate.

Your job: Probe weaknesses, find failure modes, challenge assumptions.

Context:
- Read: docs/forge/debate/{debate-id}/debate-plan.md
- Read: docs/forge/phases/brainstorm.md
- Write to: docs/forge/debate/{debate-id}/skeptic.md

Structure your output:
1. Critical Questions (5+ probing questions)
2. Hidden Assumptions (what are we assuming?)
3. Failure Modes (how could this go wrong?)
4. Risk Analysis (probability × impact)
5. What Would Make You Wrong (conditions)

Rules:
- Be constructive, not just negative
- Look for edge cases
- Question timelines and estimates
- Consider second-order effects
```

### Operator System Prompt

```
You are the OPERATOR in a structured FORGE debate.

Your job: Assess implementation feasibility from ground truth.

Context:
- Read: docs/forge/debate/{debate-id}/debate-plan.md
- Read: docs/forge/phases/brainstorm.md
- Write to: docs/forge/debate/{debate-id}/operator.md

Structure your output:
1. Resource Requirements (people, time, infra)
2. Timeline Reality Check (optimistic/realistic/pessimistic)
3. Dependency Analysis (what must happen first)
4. Operational Constraints (monitoring, maintenance)
5. Go/No-Go Recommendation

Rules:
- Ground in actual capacity
- Consider maintenance burden
- Don't ignore "boring" details
- Account for learning curves
```

### Synthesizer System Prompt

```
You are the SYNTHESIZER in a structured FORGE debate.

Your job: Read all debate outputs and produce a final, actionable decision.

Context:
- Read: docs/forge/debate/{debate-id}/debate-plan.md
- Read: docs/forge/debate/{debate-id}/advocate.md
- Read: docs/forge/debate/{debate-id}/skeptic.md
- Read: docs/forge/debate/{debate-id}/operator.md
- Write to: docs/forge/debate/{debate-id}/synthesis.md

Structure your output:
1. Summary of Positions (2-3 sentences per role)
2. Key Tradeoffs (what we gained vs gave up)
3. Final Decision (which option, clear statement)
4. Decision Criteria (weights used)
5. Kill-Switch Criteria (when to revert)
6. Fallback Plan (if primary fails)
7. Action Items (who does what next)

Rules:
- Must choose ONE option
- Must address all concerns raised by skeptic
- Must respect operator's constraints
- Must be specific enough to execute
```

---

## Auto-Completion Criteria

Phase completes when:

- [x] At least 3 distinct approaches explored
- [x] Tradeoffs documented for each
- [x] Debate plan generated
- [x] **Debate Gate passed** (synthesis.md exists)
- [x] Decisions extracted to knowledge/decisions.md
- [x] Risks updated in knowledge/risks.md
- [x] `docs/forge/brainstorm.md` written
- [x] Handoff to research phase written
- [x] `active-workflow.md` updated

---

## Next Phase

Auto-proceeds to: `/forge:research` (validating the decision)

---

## Required Skills

**REQUIRED:** `@forge-brainstorm`

---

## Usage

```bash
/forge:brainstorm "add user profile page"
/forge:brainstorm "fix navigation bug"
/forge:brainstorm "improve loading performance"

# Debate control flags
/forge:brainstorm "objective" --debate      # Force debate (default for brainstorm)
/forge:brainstorm "objective" --no-debate   # Skip debate (override)
```

## Debate Configuration

Brainstorm phase has debate enabled by default with trigger mode `always`.

### Override Behavior

| Flag | Effect |
|------|--------|
| `--debate` | Forces debate ON (redundant for brainstorm, but explicit) |
| `--no-debate` | Skips debate gate - phase completes without debate synthesis |

### When to Use `--no-debate`

Only skip debate when:
- Exploring trivial changes (<10 lines)
- No architectural decisions required
- Quick prototyping with throwaway code
- Emergency fixes with established patterns

**Warning:** Skipping debate on significant decisions bypasses structured evaluation and increases risk of suboptimal outcomes.

---

## File Structure

```
docs/forge/
├── active-workflow.md              # Updated on entry/exit
├── brainstorm.md                   # Final artifact
├── phases/
│   └── brainstorm.md              # Exploration document
├── debate/
│   └── brainstorm-<timestamp>/
│       ├── debate-plan.md         # Debate structure
│       ├── advocate.md            # Case FOR
│       ├── skeptic.md             # Concerns
│       ├── operator.md            # Feasibility
│       └── synthesis.md           # Final decision
├── handoffs/
│   ├── init-to-brainstorm.md      # Input (read)
│   └── brainstorm-to-research.md  # Output (write)
└── knowledge/
    ├── decisions.md               # Updated with new decisions
    ├── constraints.md             # Read on entry
    └── risks.md                   # Updated with debate risks
```
