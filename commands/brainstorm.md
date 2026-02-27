---
name: forge:brainstorm
description: Explore approaches through structured analysis with mandatory debate gate
disable-model-invocation: true
---

# /forge:brainstorm

Explore ideas and approaches through structured analysis with mandatory **Debate Gate**. The brainstorm phase completes only after a structured debate produces a synthesized decision.

## State Update Protocol

**ON ENTRY:**
```bash
# Generate debate ID
DEBATE_ID="brainstorm-$(date +%Y%m%d-%H%M%S)"
.claude/forge/scripts/forge-state.sh set-phase brainstorm
.claude/forge/scripts/forge-debate.mjs init --id "$DEBATE_ID" --phase brainstorm
```

**ON EXIT (after debate gate passes):**
```bash
.claude/forge/scripts/forge-state.sh complete-phase
.claude/forge/scripts/forge-state.sh set-next research
```

## Usage

```bash
/forge:brainstorm "add user profile page"
/forge:brainstorm "fix navigation bug"
/forge:brainstorm "improve loading performance"
```

## Process Overview

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  1. EXPLORE     │────▶│  2. DEBATE GATE │────▶│  3. SYNTHESIS   │
│  3+ approaches  │     │  Mandatory      │     │  Final decision │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
  docs/forge/           docs/forge/debate/      docs/forge/
  brainstorm-options.md   <id>/                 brainstorm.md
                        ├── debate-plan.md
                        ├── advocate.md
                        ├── skeptic.md
                        ├── operator.md
                        └── synthesis.md
```

## Phase 1: Explore (Generate Options)

Generate at least 3 distinct approaches:

```markdown
# Brainstorm Options: [Objective]

## Option A: [Name]
**Approach:** [Description]
**Pros:** ...
**Cons:** ...
**Complexity:** Low/Medium/High
**Estimated Effort:** [time]

## Option B: [Name]
...

## Option C: [Name]
...

## Preliminary Tradeoff Matrix

| Option | Simplicity | Performance | Maintainability | Risk |
|--------|------------|-------------|-----------------|------|
| A      | ★★★★★      | ★★★☆☆       | ★★★★☆           | Low  |
| B      | ...        | ...         | ...             | ...  |
| C      | ...        | ...         | ...             | ...  |
```

## Phase 2: Debate Gate (Mandatory)

The Debate Gate requires structured debate before proceeding. This is **not optional**.

### Step 2a: Generate Debate Plan

Create `docs/forge/debate/brainstorm-<id>/debate-plan.md`:

```markdown
# Debate Plan: Brainstorm-[ID]

**Objective:** [Clear statement of what we're deciding]
**Date:** [ISO timestamp]
**Options Under Consideration:** [List the 3+ approaches]

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
```

### Step 2b: Execute Debate

**AO Mode:**
```bash
# FORGE generates debate plan only
# AO spawns debate sessions externally

## AO Debate Spawn Plan

```bash
# Spawn debate role sessions
ao spawn <project> "FORGE: Write advocate.md for debate $DEBATE_ID"
ao spawn <project> "FORGE: Write skeptic.md for debate $DEBATE_ID"
ao spawn <project> "FORGE: Write operator.md for debate $DEBATE_ID"
ao spawn <project> "FORGE: Write synthesis.md for debate $DEBATE_ID"
```

# Wait for all files to exist, then continue
```

**Standalone Mode:**
```bash
# FORGE runs structured self-debate in single session
# Each role writes its file sequentially

.claude/forge/scripts/forge-debate.mjs run --id "$DEBATE_ID"
# This executes: advocate → skeptic → operator → synthesizer
```

### Step 2c: Debate Completion Check

```bash
.claude/forge/scripts/forge-debate.mjs check --id "$DEBATE_ID"
# Returns: complete | incomplete
# Checks all required files exist
```

**Debate Gate passes when:**
- [ ] `debate-plan.md` exists
- [ ] `advocate.md` exists (not empty)
- [ ] `skeptic.md` exists (not empty)
- [ ] `operator.md` exists (not empty)
- [ ] `synthesis.md` exists with decision
- [ ] Synthesis includes decision criteria
- [ ] Synthesis includes kill-switch criteria
- [ ] Synthesis includes fallback plan

## Phase 3: Final Brainstorm Artifact

Read synthesis and write final `docs/forge/brainstorm.md`:

```markdown
# Brainstorm: [Objective]

## Decision Summary

**Selected Approach:** [Option X - Name]
**Confidence:** [High/Medium/Low]
**Decision Date:** [ISO timestamp]
**Debate Reference:** [Link to debate files]

## Decision Criteria

| Criterion | Weight | Option A | Option B | Option C |
|-----------|--------|----------|----------|----------|
| Simplicity| 30%    | 5/5      | 3/5      | 4/5      |
| Performance| 25%   | 3/5      | 5/5      | 4/5      |
| Maintainability| 25%| 4/5   | 3/5      | 5/5      |
| Risk      | 20%    | Low      | High     | Medium   |
| **Weighted Score** | | **4.25** | **3.55** | **4.45** |

## Why This Option Won

[2-3 sentence rationale tied to criteria]

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

- Debate Plan: `docs/forge/debate/brainstorm-<id>/debate-plan.md`
- Advocate: `docs/forge/debate/brainstorm-<id>/advocate.md`
- Skeptic: `docs/forge/debate/brainstorm-<id>/skeptic.md`
- Operator: `docs/forge/debate/brainstorm-<id>/operator.md`
- Synthesis: `docs/forge/debate/brainstorm-<id>/synthesis.md`

## Next Phase Input

**For Research:** Validate [specific aspect of selected approach]
**Key Questions:**
- [Question 1]
- [Question 2]
```

## Debate Role Prompts

### Advocate System Prompt
```
You are the ADVOCATE in a structured debate.

Your job: Make the strongest possible case FOR [selected option].

Output: Write to docs/forge/debate/<id>/advocate.md

Structure:
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
You are the SKEPTIC in a structured debate.

Your job: Probe weaknesses, find failure modes, challenge assumptions.

Output: Write to docs/forge/debate/<id>/skeptic.md

Structure:
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
You are the OPERATOR in a structured debate.

Your job: Assess implementation feasibility from ground truth.

Output: Write to docs/forge/debate/<id>/operator.md

Structure:
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
You are the SYNTHESIZER in a structured debate.

Your job: Read all debate outputs and produce a final, actionable decision.

Inputs: advocate.md, skeptic.md, operator.md
Output: Write to docs/forge/debate/<id>/synthesis.md

Structure:
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

## AO Mode Behavior

In AO mode (AO_SESSION set):
1. FORGE generates debate plan and options
2. FORGE outputs `ao spawn` commands for debate roles
3. **FORGE does NOT spawn debate agents internally**
4. AO executes debate sessions externally
5. FORGE detects completion and synthesizes final artifact

## Standalone Mode Behavior

In standalone mode (no AO_SESSION):
1. FORGE generates debate plan
2. FORGE runs structured self-debate sequentially
3. Each role writes its file in order
4. Synthesis produces final artifact

## Auto-Completion Criteria

Phase auto-completes when:
- [ ] At least 3 distinct approaches explored
- [ ] Tradeoffs documented for each
- [ ] **Debate Gate passed** (all debate files exist)
- [ ] Synthesis includes decision with criteria
- [ ] Kill-switch criteria defined
- [ ] Fallback plan documented
- [ ] `docs/forge/brainstorm.md` written
- [ ] Debate artifacts linked

## Next Phase

Auto-proceeds to: `/forge:research` (validating the decision)

## Required Skills

**REQUIRED:** `@forge-brainstorm`
**REQUIRED:** `@forge-debate` (for debate gate)

## Commands

```bash
# Check debate status
/forge:debate --status

# Generate debate plan only (AO mode)
/forge:debate --plan

# Run debate in current session (standalone)
/forge:debate --run

# Check if debate gate passes
/forge:debate --check
```
