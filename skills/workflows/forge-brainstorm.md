---
name: forge-brainstorm
description: Use when exploring approaches with mandatory debate gate. AO-native - FORGE generates plans, AO executes debate sessions.
---

# FORGE Brainstorm

**Phase 2 of 10** - Explore ideas through structured analysis with mandatory **Debate Gate**.

## Philosophy

**"Debate Before Deciding"** - All brainstorms must pass through structured debate before completion.

## AO-Native Behavior

**CRITICAL:** In AO mode, FORGE does NOT spawn internal subagents.

| Mode | Behavior |
|------|----------|
| **AO Mode** (AO_SESSION set) | FORGE generates debate plan only; AO spawns debate sessions |
| **Standalone** (no AO_SESSION) | FORGE runs self-debate sequentially in session |

## When to Use

Use `/forge:brainstorm` when:
- Starting a new feature or component
- Multiple approaches could solve the problem
- Trade-offs need exploration
- Requirements need clarification

## Workflow Overview

```
┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│ 1. EXPLORE       │───▶│ 2. DEBATE GATE   │───▶│ 3. SYNTHESIZE    │
│ Generate options │    │ Mandatory debate │    │ Final decision   │
└──────────────────┘    └──────────────────┘    └──────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
  docs/forge/            docs/forge/debate/      docs/forge/
  brainstorm-options.md    <id>/                 brainstorm.md
                           ├── debate-plan.md
                           ├── advocate.md
                           ├── skeptic.md
                           ├── operator.md
                           └── synthesis.md
```

## Phase 1: Generate Options

Create 3+ distinct approaches:

```markdown
# Brainstorm Options: [Objective]

## Option A: [Name]
**Approach:** [Description]
**Pros:** ...
**Cons:** ...
**Complexity:** Low/Medium/High

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

### Step 2a: Generate Debate Plan

Create `docs/forge/debate/brainstorm-<id>/debate-plan.md`:

```markdown
# Debate Plan: Brainstorm-[ID]

**Objective:** [Clear decision statement]
**Options:** [List 3+ approaches]

## Roles

**Advocate:** Argues FOR the leading option
**Skeptic:** Argues AGAINST all options, probes weaknesses
**Operator:** Assesses implementation feasibility
**Synthesizer:** Reconciles positions, produces decision

## Rules
1. Each role produces written output
2. No role contradicts core constraints
3. All risks must be addressed or accepted
4. Decision must include kill-switch criteria
```

### Step 2b: Execute Debate

**AO Mode - External Execution:**

FORGE outputs AO commands (does NOT spawn):

```bash
## AO Debate Execution Plan

Execute via AO:
```bash
ao spawn <project> "FORGE: Write advocate.md for debate <id>"
ao spawn <project> "FORGE: Write skeptic.md for debate <id>"
ao spawn <project> "FORGE: Write operator.md for debate <id>"
ao spawn <project> "FORGE: Write synthesis.md for debate <id>"
```

Or use debate runner:
```bash
ao run-debate --id <debate-id> --mode parallel
```
```

**Standalone Mode - Sequential Execution:**

FORGE runs each role in sequence:

```bash
.claude/forge/scripts/forge-debate.mjs run --id <debate-id>
# Executes: advocate → skeptic → operator → synthesizer
```

### Step 2c: Check Debate Gate

```bash
.claude/forge/scripts/forge-debate.mjs check --id <debate-id>
# Returns: PASSED | FAILED
```

**Gate Criteria:**
- [ ] debate-plan.md exists
- [ ] advocate.md exists (not empty)
- [ ] skeptic.md exists (not empty)
- [ ] operator.md exists (not empty)
- [ ] synthesis.md exists with decision
- [ ] synthesis includes kill-switch criteria
- [ ] synthesis includes fallback plan

## Phase 3: Final Artifact

Read synthesis and write `docs/forge/brainstorm.md`:

```markdown
# Brainstorm: [Objective]

## Decision Summary
**Selected:** [Option X - Name]
**Confidence:** [High/Medium/Low]
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
[2-3 sentence rationale]

## Kill-Switch Criteria
**Revert to Option [Y] if:**
- [Specific condition 1]
- [Specific condition 2]

## Fallback Plan
If primary approach fails:
1. [Fallback step 1]
2. [Fallback step 2]

## Risks Accepted

| Risk | Mitigation | Owner |
|------|------------|-------|
| [Risk 1] | [Mitigation] | [Who] |

## Debate Artifacts
- [Debate Plan](docs/forge/debate/<id>/debate-plan.md)
- [Advocate](docs/forge/debate/<id>/advocate.md)
- [Skeptic](docs/forge/debate/<id>/skeptic.md)
- [Operator](docs/forge/debate/<id>/operator.md)
- [Synthesis](docs/forge/debate/<id>/synthesis.md)

## Next Phase
→ `/forge:research` to validate decision
```

## Karpathy Assessment

Rate each approach against Karpathy guidelines:

| Guideline | Rating | Notes |
|-----------|--------|-------|
| Simplicity | ⭐⭐⭐⭐⭐ | [Explanation] |
| Surgical precision | ⭐⭐⭐⭐☆ | [Lines of change] |
| Testability | ⭐⭐⭐⭐⭐ | [How testable] |
| Evidence-based | ⭐⭐⭐⭐☆ | [Supporting evidence] |

## Debate Role Prompts

### Advocate System Prompt
```
You are the ADVOCATE in a structured debate.

Your job: Make the strongest case FOR [selected option].

Output: Write to docs/forge/debate/<id>/advocate.md

Structure:
1. Core Argument (3 sentences)
2. Key Strengths (bullet list)
3. Comparative Advantages (vs others)
4. Success Criteria (measurable)
5. Risk Acceptance (acceptable risks)

Rules:
- Be persuasive but honest
- Don't dismiss valid concerns
- Quantify benefits where possible
```

### Skeptic System Prompt
```
You are the SKEPTIC in a structured debate.

Your job: Probe weaknesses, find failure modes.

Output: Write to docs/forge/debate/<id>/skeptic.md

Structure:
1. Critical Questions (5+ questions)
2. Hidden Assumptions
3. Failure Modes
4. Risk Analysis (probability × impact)
5. What Would Make You Wrong

Rules:
- Be constructive, not just negative
- Look for edge cases
- Consider second-order effects
```

### Operator System Prompt
```
You are the OPERATOR in a structured debate.

Your job: Assess implementation feasibility.

Output: Write to docs/forge/debate/<id>/operator.md

Structure:
1. Resource Requirements
2. Timeline Reality Check
3. Dependency Analysis
4. Operational Constraints
5. Go/No-Go Recommendation

Rules:
- Ground in actual capacity
- Consider maintenance burden
- Account for learning curves
```

### Synthesizer System Prompt
```
You are the SYNTHESIZER in a structured debate.

Your job: Read all outputs and produce final decision.

Inputs: advocate.md, skeptic.md, operator.md
Output: Write to docs/forge/debate/<id>/synthesis.md

Structure:
1. Summary of Positions
2. Key Tradeoffs
3. Final Decision
4. Decision Criteria
5. Kill-Switch Criteria
6. Fallback Plan
7. Action Items

Rules:
- Must choose ONE option
- Must address all concerns
- Must include kill-switch
```

## Commands

```bash
# Initialize debate
.claude/forge/scripts/forge-debate.mjs init --phase brainstorm

# Check debate status
/forge:debate --status

# Generate AO plan
/forge:debate --plan --id <id>

# Run standalone debate
/forge:debate --run --id <id>

# Check gate
/forge:debate --check --id <id>
```

## Completion Protocol

**Brainstorm phase completes ONLY when:**
1. 3+ approaches explored
2. Debate plan generated
3. **Debate Gate passed** (all 5 files exist)
4. Synthesis includes decision with criteria
5. Kill-switch criteria defined
6. Fallback plan documented
7. Final brainstorm.md written

**Next Phase:** `/forge:research`

## Templates

Role templates available at:
- `templates/debate/advocate.md`
- `templates/debate/skeptic.md`
- `templates/debate/operator.md`
- `templates/debate/synthesis.md`

## Schema Reference

See `docs/forge/debate-schema.md` for full specification.
